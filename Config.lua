-- 配置常量
MyUI_Config = {
    -- 框架配置
    frame = {
        width = 400,
        height = 300,
        position = {"CENTER", UIParent, "CENTER", 0, 0},
        backgroundColor = {0.1, 0.1, 0.1, 0.9},
        borderColor = {0.5, 0.5, 0.5, 1},
        title = "多频道喊话助手",
    },
    
    -- 按钮配置
    buttons = {
        height = 25,
        width = 150,
        spacing = 35,
        startY = -40
    },
    
    -- 输入框配置
    inputs = {
        height = 25,
        width = 200,
        spacing = 50
    },
    
    -- 颜色配置
    colors = {
        success = {0, 1, 0, 1},
        error = {1, 0, 0, 1},
        warning = {1, 1, 0, 1},
        info = {0.5, 0.5, 1, 1}
    }
}

-- 按钮定义
MyUI_Buttons = {
    {
        name = "btnSave",
        text = "发送",
        tooltip = "保存当前输入的内容",
        width = 80
    },
    {
        name = "btnLoad",
        text = "取消",
        tooltip = "加载已保存的配置",
        width = 80
    },
    {
        name = "btnProcess",
        text = "更新",
        tooltip = "处理输入框中的文本",
        width = 80
    }
}

-- 输入框定义
MyUI_Inputs = {
    {
        name = "inputName",
        multiLine = false,
        label = "广告:",
        default = "",
        maxLetters = 1000
    },
    {
        name = "inputValue",
        label = "间隔:",
        default = "6",
        maxLetters = 10,
        width = 180,
        numeric = true
    }
}

-- 复选框
MyUI_Checkboxes = {
    {
        name = "频道",
        label = "喊话",
        default = false,
        tooltip = "往该频道发送"
    },
    {
        name = "频道",
        label = "交易",
        default = false,
        tooltip = "往该频道发送"
    },
    {
        name = "频道",
        label = "LFT",
        default = false,
        tooltip = "往该频道发送"
    }
}