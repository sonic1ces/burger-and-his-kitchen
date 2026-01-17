<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>BAHKF Ultra Engine v2.0</title>
    <style type="text/css">
        body { 
            margin: 0; 
            background: radial-gradient(circle, #333 0%, #050505 100%); 
            color: #eee; 
            font-family: 'Segoe UI', Tahoma, sans-serif; 
            display: flex; 
            flex-direction: column; 
            align-items: center; 
            justify-content: center; 
            height: 100vh; 
            overflow: hidden;
        }
        #player-frame {
            background: linear-gradient(to bottom, #222, #111);
            padding: 12px;
            border-radius: 10px;
            border: 1px solid #444;
            box-shadow: 0 25px 60px rgba(0,0,0,0.8), inset 0 1px 2px rgba(255,255,255,0.1);
        }
        #screen-wrapper {
            position: relative;
            background: #000;
            border: 2px solid #000;
            line-height: 0;
            overflow: hidden;
        }
        #screen-wrapper::after {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0; height: 45%;
            background: linear-gradient(to bottom, rgba(255,255,255,0.08) 0%, rgba(255,255,255,0) 100%);
            pointer-events: none;
            z-index: 5;
        }
        canvas { 
            display: block;
            image-rendering: pixelated; 
            cursor: crosshair;
        }
        .dock {
            margin-top: 12px;
            background: linear-gradient(to bottom, #333 0%, #1a1a1a 100%);
            padding: 10px 20px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            gap: 15px;
            border-top: 1px solid #555;
        }
        .btn-glossy {
            background: linear-gradient(to bottom, #4facfe 0%, #00f2fe 100%);
            border: none;
            padding: 7px 20px;
            color: white;
            font-weight: bold;
            font-size: 12px;
            border-radius: 15px;
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(0,0,0,0.4);
        }
        .led {
            width: 8px; height: 8px;
            background: #400; 
            border-radius: 50%;
            transition: 0.3s;
        }
        .info { font-size: 11px; color: #888; text-transform: uppercase; }
        b { color: #4facfe; }
    </style>
</head>
<body>

    <div id="player-frame">
        <div id="screen-wrapper">
            <canvas id="screen" width="800" height="600"></canvas>
        </div>

        <div class="dock">
            <input type="file" id="fileInput" style="display:none" accept=".bahkf" />
            <button class="btn-glossy" onclick="document.getElementById('fileInput').click()">LOAD .BAHKF</button>
            
            <div class="info">
                System: <span id="status">Ready</span> | Scene: <b id="curScene">None</b>
            </div>
            <div id="statusLed" class="led"></div>
        </div>
    </div>

<script type="text/javascript">
// <![CDATA[
    // --- СИСТЕМА ЗАЩИТЫ ---
    (function checkAccess() {
        const isAuth = localStorage.getItem('isAuth') === 'true';
        // Если пользователь не авторизован, отправляем на страницу входа
        if (!isAuth) {
            window.location.href = "Login.aspx";
            return;
        }
    })();

    const XOR_KEY = 0x7A;
    const canvas = document.getElementById("screen");
    const ctx = canvas.getContext("2d");
    const fileInput = document.getElementById("fileInput");
    const statusTxt = document.getElementById("status");
    const sceneTxt = document.getElementById("curScene");
    const led = document.getElementById("statusLed");

    let gameData = { assets: {}, scenes: [] };
    let currentScene = null;
    let score = 0;
    const imageCache = {};

    // 1. УСИЛЕННАЯ АВТОЗАГРУЗКА
    window.addEventListener('load', () => {
        statusTxt.textContent = "Loading project.bahkf...";
        fetch('project.bahkf')
            .then(response => {
                if (!response.ok) throw new Error("File not found");
                return response.arrayBuffer();
            })
            .then(buffer => {
                processData(new Uint8Array(buffer));
                console.log("Auto-load successful");
            })
            .catch(err => {
                statusTxt.textContent = "Standby";
                console.log("No project.bahkf found or access denied. Manual load required.");
            });
    });

    fileInput.onchange = (e) => {
        const file = e.target.files[0];
        if (!file) return;
        const reader = new FileReader();
        reader.onload = () => processData(new Uint8Array(reader.result));
        reader.readAsArrayBuffer(file);
    };

    function processData(raw) {
        if (String.fromCharCode(...raw.slice(0, 4)) !== "BAHK") {
            alert("Error: Not a BAHKF file");
            return;
        }
        const decrypted = raw.slice(8).map(b => b ^ XOR_KEY);
        try {
            const json = JSON.parse(new TextDecoder("utf-8").decode(decrypted));
            gameData.assets = json.assets || {};
            parseLogic(json.logic || []);
            
            statusTxt.textContent = "Running";
            led.style.background = "#0f0";
            led.style.boxShadow = "0 0 8px #0f0";
            
            if (gameData.scenes.length > 0) loadScene(gameData.scenes[0].name);
        } catch (err) {
            statusTxt.textContent = "Logic Error";
        }
    }

    function parseLogic(logicStrings) {
        gameData.scenes = [];
        let tempScene = null;
        logicStrings.forEach(line => {
            const p = line.trim().split(/\s+/);
            const cmd = p[0];
            switch(cmd) {
                case "SCENE":
                    tempScene = { name: p[1], images: [], texts: [], zones: [], waitNext: null };
                    gameData.scenes.push(tempScene);
                    break;
                case "IMAGE":
                    if (tempScene) tempScene.images.push({ id: p[1], x: +p[2], y: +p[3] });
                    break;
                case "WAIT_CLICK":
                    if (tempScene) tempScene.waitNext = p[1];
                    break;
                case "TEXT":
                    if (tempScene) {
                        const match = line.match(/"([^"]+)"/);
                        const content = match ? match[1] : "";
                        const meta = line.split('"')[2]?.trim().split(/\s+/) || [0, 0];
                        tempScene.texts.push({ str: content, x: +meta[0], y: +meta[1] });
                    }
                    break;
                case "CLICK_ZONE":
                    if (tempScene) tempScene.zones.push({ x: +p[1], y: +p[2], w: +p[3], h: +p[4], action: p[5] });
                    break;
            }
        });
    }

    async function loadScene(sceneName) {
        // НОВАЯ ЛОГИКА: ПРОВЕРКА НА ВЫХОД
        if (sceneName === "EXIT_TO_LOGIN") {
            window.location.href = "Login.aspx";
            return;
        }

        currentScene = gameData.scenes.find(s => s.name === sceneName);
        if (!currentScene) return;

        sceneTxt.textContent = sceneName;
        ctx.fillStyle = "#000";
        ctx.fillRect(0, 0, canvas.width, canvas.height);

        for (let i = 0; i < currentScene.images.length; i++) {
            const imgData = currentScene.images[i];
            const assetSrc = gameData.assets[imgData.id];
            if (assetSrc) {
                if (!imageCache[imgData.id]) {
                    const imgObj = new Image();
                    imgObj.src = assetSrc.startsWith('data:') ? assetSrc : `data:image/png;base64,${assetSrc}`;
                    await new Promise(r => imgObj.onload = r);
                    imageCache[imgData.id] = imgObj;
                }
                const pic = imageCache[imgData.id];
                if (i === 0 || imgData.id.toLowerCase().includes("bg")) {
                    ctx.drawImage(pic, 0, 0, canvas.width, canvas.height);
                } else {
                    ctx.drawImage(pic, imgData.x, imgData.y);
                }
            }
        }

        ctx.font = "24px 'Segoe UI', Arial";
        currentScene.texts.forEach(t => {
            const finalStr = t.str.replace("{score}", score);
            ctx.strokeStyle = "rgba(0,0,0,0.8)";
            ctx.lineWidth = 4;
            ctx.strokeText(finalStr, t.x, t.y);
            ctx.fillStyle = "#fff";
            ctx.fillText(finalStr, t.x, t.y);
        });
    }

    canvas.onclick = (e) => {
        if (!currentScene) return;
        const rect = canvas.getBoundingClientRect();
        const mx = (e.clientX - rect.left) * (canvas.width / rect.width);
        const my = (e.clientY - rect.top) * (canvas.height / rect.height);

        let clicked = false;
        currentScene.zones.forEach(z => {
            if (mx >= z.x && mx <= z.x + z.w && my >= z.y && my <= z.y + z.h) {
                clicked = true;
                if (z.action === "ADD_SCORE") {
                    score++;
                    loadScene(currentScene.name);
                } else {
                    loadScene(z.action); // Здесь сработает EXIT_TO_LOGIN
                }
            }
        });
        if (!clicked && currentScene.waitNext) loadScene(currentScene.waitNext);
    };
// ]]>
</script>
</body>
</html>