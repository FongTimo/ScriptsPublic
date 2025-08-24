local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("GitHub Loader", "Sentinel")

-- Основная вкладка
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("GitHub Script Loader")

-- Поле для ввода ссылки
local UrlInput = MainSection:NewTextBox("GitHub Raw URL", "Вставьте ссылку на raw файл", function(text)
    _G.GithubUrl = text
end)

-- Кнопка выполнения
MainSection:NewButton("Execute Script", "Запустить скрипт", function()
    if _G.GithubUrl and _G.GithubUrl ~= "" then
        pcall(function()
            local scriptContent = game:HttpGet(_G.GithubUrl)
            local loadedFunction = loadstring(scriptContent)
            if loadedFunction then
                loadedFunction()
                Library:Notification("Успех", "Скрипт успешно выполнен!", "ОК")
            else
                Library:Notification("Ошибка", "Не удалось загрузить скрипт", "ОК")
            end
        end)
    else
        Library:Notification("Ошибка", "Введите ссылку сначала!", "ОК")
    end
end)

-- Кнопка очистки
MainSection:NewButton("Clear URL", "Очистить поле", function()
    _G.GithubUrl = ""
    UrlInput:SetText("")
end)

-- Вкладка с примерами
local ExamplesTab = Window:NewTab("Examples")
local ExamplesSection = ExamplesTab:NewSection("Примеры ссылок")

ExamplesSection:NewButton("Infinite Yield", "Вставить ссылку Infinite Yield", function()
    UrlInput:SetText("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
end)

ExamplesSection:NewButton("CMD-X", "Вставить ссылку CMD-X", function()
    UrlInput:SetText("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source")
end)

-- Вкладка информации
local InfoTab = Window:NewTab("Info")
local InfoSection = InfoTab:NewSection("Информация")

InfoSection:NewLabel("Как использовать:")
InfoSection:NewLabel("1. Вставьте raw ссылку в поле")
InfoSection:NewLabel("2. Нажмите 'Execute Script'")
InfoSection:NewLabel("3. Скрипт выполнится автоматически")

InfoSection:NewLabel("Raw ссылка должна начинаться с:")
InfoSection:NewLabel("https://raw.githubusercontent.com/...")
