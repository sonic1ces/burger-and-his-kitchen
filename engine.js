/**
 * BAHKF Ultra Engine v2.0
 * Полный системный скрипт (Ядро + Защита)
 * (c) 2026 BAHK Corporation
 */

(function securityCore() {
    // 1. ПРОВЕРКА ДОСТУПА
    const isAuth = localStorage.getItem('isAuth') === 'true';
    const path = window.location.pathname.toLowerCase();
    
    // Страницы, на которые нельзя без логина
    const protectedPages = ["games.aspx", "playingfun.aspx"];
    const isProtected = protectedPages.some(page => path.includes(page));

    if (isProtected && !isAuth) {
        // Если не авторизован — перекидываем на логин
        window.location.href = "Login.aspx";
        return; 
    }
    
    console.log("BAHK OS: Система безопасности активна. Статус: " + (isAuth ? "ADMIN" : "GUEST"));
})();

// --- КОНСТАНТЫ И ПЕРЕМЕННЫЕ ДВИЖКА ---
const XOR_KEY = 0x7A;
const canvas = document.getElementById("screen");
const ctx = canvas ? canvas.getContext("2d") : null;
const fileInput = document.getElementById("fileInput");
const statusTxt = document.getElementById("status");
const sceneTxt = document.getElementById("curScene");
const led = document.getElementById("statusLed");

let gameData = { assets: {}, scenes: [] };
let currentScene = null;
let score = 0;
const imageCache = {};

// --- 1. ЗАГРУЗКА ДАННЫХ ---

window.addEventListener('load', () => {
    // Автоматическая попытка загрузки проекта
    if (canvas) {
        fetch('project.bahkf')
            .then(response => {
                if (!response.ok) throw new Error();
                return response.arrayBuffer();
            })
            .then(buffer => processData(new Uint8Array(buffer)))
            .catch(() => {
                if (statusTxt) statusTxt.textContent = "Standby (Manual Load Required)";
                console.log("Файл project.bahkf не найден.");
            });
    }
});

if (fileInput) {
    fileInput.onchange = (e) => {
        const file = e.target.files[0];
        if (!file) return;
        const reader = new FileReader();
        reader.onload = () => processData(new Uint8Array(reader.result));
        reader.readAsArrayBuffer(file);
    };
}

// --- 2. ДЕШИФРОВКА И ПАРСИНГ ---

function processData(raw) {
    // Проверка сигнатуры файла
    if (String.fromCharCode(...raw.slice(0, 4)) !== "BAHK") {
        alert("Ошибка: Неверный формат файла .BAHKF");
        return;
    }

    // XOR Дешифровка (начиная с 8 байта)
    const decrypted = raw.slice(8).map(b => b ^ XOR_KEY);
    
    try {
        const json = JSON.parse(new TextDecoder("utf-8").decode(decrypted));
        gameData.assets = json.assets || {};
        parseLogic(json.logic || []);
        
        if (statusTxt) statusTxt.textContent = "Running";
        if (led) {
            led.style.background = "#0f0";
            led.style.boxShadow = "0 0 8px #0f0";
        }
        
        if (gameData.scenes.length > 0) loadScene(gameData.scenes[0].name);
    } catch (err) {
        if (statusTxt) statusTxt.textContent = "Logic Error";
        console.error("Ошибка парсинга JSON:", err);
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

// --- 3. РЕНДЕРИНГ (ОТРИСОВКА) ---

async function loadScene(sceneName) {
    // ПРОВЕРКА НА ВЫХОД
    if (sceneName === "EXIT_TO_LOGIN") {
        window.location.href = "Login.aspx";
        return;
    }

    currentScene = gameData.scenes.find(s => s.name === sceneName);
    if (!currentScene || !ctx) return;

    if (sceneTxt) sceneTxt.textContent = sceneName;
    
    // Очистка экрана
    ctx.fillStyle = "#000";
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    // Отрисовка слоев изображений
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
            
            // Если ID содержит "bg" — растягиваем на весь экран
            if (i === 0 || imgData.id.toLowerCase().includes("bg")) {
                ctx.drawImage(pic, 0, 0, canvas.width, canvas.height);
            } else {
                ctx.drawImage(pic, imgData.x, imgData.y);
            }
        }
    }

    // Отрисовка текста
    ctx.font = "24px 'MS Sans Serif', Tahoma, sans-serif";
    currentScene.texts.forEach(t => {
        const finalStr = t.str.replace("{score}", score);
        ctx.strokeStyle = "rgba(0,0,0,0.8)";
        ctx.lineWidth = 4;
        ctx.strokeText(finalStr, t.x, t.y);
        ctx.fillStyle = "#fff";
        ctx.fillText(finalStr, t.x, t.y);
    });
}

// --- 4. КЛИКИ ---

if (canvas) {
    canvas.onclick = (e) => {
        if (!currentScene) return;
        const rect = canvas.getBoundingClientRect();
        const mx = (e.clientX - rect.left) * (canvas.width / rect.width);
        const my = (e.clientY - rect.top) * (canvas.height / rect.height);

        let wasZoneClicked = false;
        currentScene.zones.forEach(z => {
            if (mx >= z.x && mx <= z.x + z.w && my >= z.y && my <= z.y + z.h) {
                wasZoneClicked = true;
                if (z.action === "ADD_SCORE") {
                    score++;
                    loadScene(currentScene.name);
                } else {
                    loadScene(z.action);
                }
            }
        });

        if (!wasZoneClicked && currentScene.waitNext) {
            loadScene(currentScene.waitNext);
        }
    };
}