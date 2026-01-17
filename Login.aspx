<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Система защиты BAHK.ORG</title>
    <style type="text/css">
        body { 
            background: #008080; /* Тот самый бирюзовый цвет */
            font-family: "MS Sans Serif", "Tahoma", sans-serif; 
            font-size: 11px;
            display: flex; 
            justify-content: center; 
            align-items: center; 
            height: 100vh; 
            margin: 0;
        }

        /* Основное окно в стиле Win98 */
        .login-window { 
            background: #c0c0c0; 
            width: 320px;
            border-left: 2px solid #ffffff;
            border-top: 2px solid #ffffff;
            border-right: 2px solid #000000;
            border-bottom: 2px solid #000000;
            padding: 2px;
        }

        .title-bar {
            background: linear-gradient(90deg, #000080, #1084d0);
            color: white;
            padding: 3px 5px 3px 10px;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .content {
            padding: 20px;
            display: flex;
            gap: 15px;
        }

        .icon-side {
            flex-shrink: 0;
        }

        .form-side {
            flex-grow: 1;
        }

        label {
            display: block;
            margin-bottom: 2px;
        }

        input { 
            width: 100%; 
            margin-bottom: 12px; 
            font-size: 11px;
            border-left: 2px solid #808080;
            border-top: 2px solid #808080;
            border-right: 2px solid #ffffff;
            border-bottom: 2px solid #ffffff;
            padding: 2px;
            box-sizing: border-box;
        }

        input:focus {
            outline: none;
            background: #ffffcc; /* Легкая подсветка фокуса в стиле старых форм */
        }

        .buttons {
            text-align: right;
            margin-top: 5px;
        }

        .btn-95 { 
            background: #c0c0c0;
            border-left: 1px solid #ffffff;
            border-top: 1px solid #ffffff;
            border-right: 1px solid #000000;
            border-bottom: 1px solid #000000;
            padding: 4px 20px;
            min-width: 75px;
            cursor: pointer;
            font-family: inherit;
            font-size: 11px;
            margin-left: 5px;
        }

        .btn-95:active {
            border-left: 1px solid #000000;
            border-top: 1px solid #000000;
            border-right: 1px solid #ffffff;
            border-bottom: 1px solid #ffffff;
            outline: 1px dotted black;
            outline-offset: -4px;
        }

        .btn-default {
            font-weight: bold; /* Жирный шрифт для основной кнопки */
        }
    </style>
</head>
<body>

<div class="login-window">
    <div class="title-bar">
        <span>Вход в систему</span>
        <div style="background: #c0c0c0; color: black; border: 1px solid white; padding: 0 4px; font-size: 9px; cursor: default;">X</div>
    </div>
    
    <div class="content">
        <div class="icon-side">
            <img src="https://web.archive.org/web/20091024213346im_/http://geocities.com/SiliconValley/6170/key.gif" width="32" height="32" alt="Key" />
        </div>

        <div class="form-side">
            <p style="margin: 0 0 15px 0;">Введите имя пользователя и пароль для доступа к сети BAHK.</p>
            
            <label for="u"><u>И</u>мя пользователя:</label>
            <input type="text" id="u" />
            
            <label for="p"><u>П</u>ароль:</label>
            <input type="password" id="p" />
            
            <div class="buttons">
                <button class="btn-95 btn-default" onclick="doLogin()">ОК</button>
                <button class="btn-95" onclick="alert('Доступ запрещен!')">Отмена</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
// <![CDATA[
    function doLogin() {
        var user = document.getElementById('u').value;
        if (user.length > 0) {
            localStorage.setItem('isAuth', 'true');
            localStorage.setItem('userName', user);
            window.location.href = 'index.aspx'; // Возвращаемся на главную
        } else {
            alert("Ошибка: Поле 'Имя пользователя' не может быть пустым.");
        }
    }

    // Позволяет нажимать Enter для входа
    document.onkeydown = function(e) {
        if (e.keyCode === 13) doLogin();
    };
// ]]>
</script>

</body>
</html>