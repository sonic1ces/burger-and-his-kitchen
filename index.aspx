<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>ДОБРО ПОЖАЛОВАТЬ НА BAHK.ORG</title>
    <style type="text/css">
        /* Сетчатый фон в стиле старых обоев Windows */
        body { 
            background-color: #008080; 
            font-family: "MS Sans Serif", "Tahoma", sans-serif; 
            font-size: 11px;
            margin: 0; 
            padding: 20px; 
        }

        /* Эффект выпуклой кнопки/окна */
        .win-panel {
            background: #c0c0c0;
            border-left: 2px solid #ffffff;
            border-top: 2px solid #ffffff;
            border-right: 2px solid #000000;
            border-bottom: 2px solid #000000;
            padding: 2px;
            width: 700px;
            margin: 0 auto;
        }

        .win-header {
            background: linear-gradient(90deg, #000080, #1084d0);
            color: white;
            padding: 3px 10px;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .win-content {
            padding: 15px;
            color: #000;
        }

        /* Навигация как в старых браузерах */
        .nav-bar {
            background: #c0c0c0;
            border-bottom: 1px solid #808080;
            padding: 5px;
            margin-bottom: 10px;
        }

        .nav-bar a {
            color: #000;
            text-decoration: none;
            padding: 2px 8px;
            border: 1px solid transparent;
        }

        .nav-bar a:hover {
            border-left: 1px solid #ffffff;
            border-top: 1px solid #ffffff;
            border-right: 1px solid #808080;
            border-bottom: 1px solid #808080;
        }

        /* Рамка "вдавленная" для контента */
        .inset-box {
            background: #ffffff;
            border-left: 2px solid #808080;
            border-top: 2px solid #808080;
            border-right: 2px solid #ffffff;
            border-bottom: 2px solid #ffffff;
            padding: 10px;
            margin-top: 10px;
        }

        .btn-95 {
            background: #c0c0c0;
            border-left: 1px solid #ffffff;
            border-top: 1px solid #ffffff;
            border-right: 1px solid #000000;
            border-bottom: 1px solid #000000;
            padding: 5px 15px;
            cursor: pointer;
            text-decoration: none;
            color: black;
            display: inline-block;
            font-size: 11px;
        }

        .btn-95:active {
            border-left: 1px solid #000000;
            border-top: 1px solid #000000;
            border-right: 1px solid #ffffff;
            border-bottom: 1px solid #ffffff;
        }

        .status-bar {
            margin-top: 15px;
            border-top: 1px solid #808080;
            padding-top: 5px;
            display: flex;
            gap: 10px;
        }

        .status-field {
            border: 1px solid #808080;
            padding: 2px 5px;
            background: #c0c0c0;
            flex-grow: 1;
        }

        .blink { animation: blinker 1s linear infinite; }
        @keyframes blinker { 50% { opacity: 0; } }

        .hidden { display: none; }
        
        h1 { font-size: 18px; margin: 0; }
        marquee { background: #000; color: #0f0; font-family: Courier; padding: 3px; }
    </style>
</head>
<body>

<div class="win-panel">
    <div class="win-header">
        <span>BAHK_Portal.exe</span>
        <span style="font-family: monospace;">[?] [X]</span>
    </div>

    <div class="nav-bar">
        <a href="index.aspx"><u>F</u>ile</a>
        <a href="#" onclick="toggleAuth(); return false;"><u>L</u>ogin</a>
        <a href="#"><u>V</u>iew</a>
        <a href="#"><u>H</u>elp</a>
    </div>

    <div class="win-content">
        <center>
            <h1><img src="https://web.archive.org/web/20091027083038im_/http://geocities.com/SiliconValley/Heights/7032/construct2.gif" border="0" alt="" /> 
            BAHK PORTAL 2026 
            <img src="https://web.archive.org/web/20091027083038im_/http://geocities.com/SiliconValley/Heights/7032/construct2.gif" border="0" alt="" /></h1>
            <marquee scrollamount="3">ВНИМАНИЕ: Портал работает в режиме совместимости с Ultra Engine v2.0... Добро пожаловать, путник...</marquee>
        </center>

        <div class="inset-box">
            <b>О проекте:</b><br />
            Данный узел сети оптимизирован для просмотра в Internet Explorer 4.0 при разрешении 800x600. 
            Здесь хранятся артефакты цифровой эпохи и исполняемые файлы .BAHKF.
        </div>

        <div class="inset-box" style="background: #c0c0c0;">
            <b><span id="lock-icon">🔒</span> AREA 51: Мини-игры</b>
            
            <div id="guestContent">
                <p style="color: #ff0000; font-weight: bold;">[!] ОШИБКА ДОСТУПА: ТРЕБУЕТСЯ АВТОРИЗАЦИЯ</p>
                <p>Для запуска Ultra Engine вставьте ключ или войдите в систему.</p>
                <a href="#" class="btn-95" onclick="toggleAuth(); return false;">ВОЙТИ</a>
            </div>

            <div id="authorizedContent" class="hidden">
                <p>Статус: <span class="blink" style="color: #008000; font-weight: bold;">АВТОРИЗОВАНО</span></p>
                <p>Добро пожаловать, <b>Admin_BAHK</b>. Ядро системы готово к пуску.</p>
                <a href="PlayingFun.aspx" class="btn-95">ЗАПУСТИТЬ .BAHKF ПЛЕЕР</a>
                <a href="#" class="btn-95" onclick="toggleAuth(); return false;">ВЫХОД</a>
            </div>
        </div>

        <div class="status-bar">
            <div class="status-field">User: <span id="userNameLabel">Guest</span></div>
            <div class="status-field">System: ONLINE</div>
            <div class="status-field" style="flex-grow: 0; width: 100px;">1:35 AM</div>
        </div>
    </div>
</div>

<div style="text-align: center; margin-top: 20px; color: white;">
    <p>Best viewed with:<br />
    <img src="https://web.archive.org/web/20091023120117im_/http://geocities.com/p_m_stephens/images/ie_logo.gif" alt="IE" />
    <img src="https://web.archive.org/web/20091024040904im_/http://geocities.com/m_p_stephens/images/ns_logo.gif" alt="Netscape" /></p>
    <p>(c) 2026-1998 BAHK Corporation</p>
</div>

<script type="text/javascript">
// <![CDATA[
    function toggleAuth() {
        var auth = localStorage.getItem('isAuth') === 'true';
        localStorage.setItem('isAuth', !auth);
        location.reload();
    }

    window.onload = function() {
        var isAuth = localStorage.getItem('isAuth') === 'true';
        if (isAuth) {
            document.getElementById('authorizedContent').className = '';
            document.getElementById('guestContent').className = 'hidden';
            document.getElementById('userNameLabel').innerHTML = 'Admin_BAHK';
            document.getElementById('lock-icon').innerHTML = '🔓';
        }
    };
// ]]>
</script>
</body>
</html>