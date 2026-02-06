MyUI_Localization = {
    ["zhCN"] = {
        ["MyUI Addon"] = "我的UI插件",
        ["Button 1"] = "按钮1",
        ["Button 2"] = "按钮2",
        ["Clear Inputs"] = "清空输入",
        ["Toggle UI"] = "切换界面",
        ["Input Text 1:"] = "输入文本1：",
        ["Input Text 2:"] = "输入文本2：",
        ["Multi-line Text:"] = "多行文本：",
        ["Button 1 clicked!"] = "按钮1被点击！",
        ["Button 2 clicked!"] = "按钮2被点击！",
        ["Button 3 clicked!"] = "按钮3被点击！",
        ["Button 4 clicked!"] = "按钮4被点击！",
        ["Input 1: %s"] = "输入1：%s",
        ["Multi-line text: %s"] = "多行文本：%s",
        ["All input fields cleared!"] = "所有输入框已清空！",
        ["UI hidden. Settings saved."] = "界面隐藏。设置已保存。",
        ["MyUI Addon loaded! Type /myui to show/hide the interface."] = "MyUI插件已加载！输入 /myui 显示/隐藏界面。"
    },
    ["enUS"] = {
        -- 英文版本
    }
}

-- 根据当前游戏语言选择本地化
local locale = GetLocale()
if MyUI_Localization[locale] then
    for k, v in pairs(MyUI_Localization[locale]) do
        MyUI_Localization[k] = v
    end
end