-- 插件名称和命名空间
local addonName, addonTable = ...
local MyUI = {}

-- 存储到addonTable以供其他文件访问
addonTable.MyUI = MyUI

-- 加载配置
MyUI.Config = MyUI_Config or {}
MyUI.Buttons = MyUI_Buttons or {}
MyUI.Inputs = MyUI_Inputs or {}

-- 加载本地化
MyUI.L = setmetatable({}, {
    __index = function(t, k)
        return k
    end
})

if MyUI_Localization then
    for k, v in pairs(MyUI_Localization) do
        MyUI.L[k] = v
    end
end

-- 创建UI元素
function MyUI:CreateUI()
    -- 创建主框架
    self.mainFrame = self:CreateMainFrame()

    -- 创建输入框
    self:CreateInputs()

    -- self:CreateCheckbox()

    -- 创建按钮
    self:CreateButtons()

    -- 初始化事件处理器
    if MyUI_EventHandlers and MyUI_EventHandlers.Initialize then
        MyUI_EventHandlers:Initialize()
    end
end

-- 创建主框架
function MyUI:CreateMainFrame()
    local config = self.Config.frame or {}

    local frame = CreateFrame("Frame", "MyUIMainFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(config.width or 350, config.height or 280)
    frame:SetPoint(unpack(config.position or {"CENTER", UIParent, "CENTER", 0, 0}))
    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    -- 标题
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("TOP", frame, "TOP", 0, -8)
    frame.title:SetText(config.title or "MyUI 插件")

    -- 背景
    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints()
    frame.bg:SetColorTexture(unpack(config.backgroundColor or {0.1, 0.1, 0.1, 0.9}))

    return frame
end

-- 创建输入框
function MyUI:CreateInputs()
    local frame = self.mainFrame
    local yOffset = MyUI_Config.buttons.startY or -40

    for i, inputDef in ipairs(MyUI.Inputs or {}) do
        if inputDef.multiLine then
            -- 多行输入框
            local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            label:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, yOffset)
            label:SetText(inputDef.label)

            local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
            scrollFrame:SetSize(180, 60)
            scrollFrame:SetPoint("TOP", label, "BOTTOM", 0, -2)

            local editBox = CreateFrame("EditBox", nil, scrollFrame)
            editBox:SetMultiLine(true)
            editBox:SetFontObject(ChatFontNormal)
            editBox:SetWidth(scrollFrame:GetWidth())
            editBox:SetHeight(scrollFrame:GetHeight())
            editBox:SetAutoFocus(false)
            editBox:SetText(inputDef.default or "")

            scrollFrame:SetScrollChild(editBox)

            -- 存储引用
            frame[inputDef.name] = editBox
            yOffset = yOffset - 90
        else
            -- 单行输入框
            local label = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            label:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, yOffset)
            label:SetText(inputDef.label)

            local input = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
            local height = MyUI_Config.inputs.height or 25
            if i == 1 then
                height = height + 50 -- 第一个输入框稍高一些
            end
            input:SetSize(inputDef.width or 180, height)
            input:SetPoint("LEFT", label, "RIGHT", 10, 0)
            input:SetAutoFocus(false)
            input:SetMaxLetters(inputDef.maxLetters or 20)
            input:SetText(inputDef.default or "")

            -- 存储引用
            frame[inputDef.name] = input
            yOffset = yOffset - MyUI_Config.inputs.spacing
        end
    end
end

-- 创建一个简单的CheckBox
function MyUI:CreateCheckbox()
    print(">>> MyUI:开始创建CheckBox")

    -- 1. 检查self和mainFrame
    if not self then
        print("[错误] self参数为空")
        return nil
    end

    local frame = self.mainFrame
    if not frame then
        print("[错误] mainFrame不存在，请先创建主框架")
        return nil
    end
    print("主框架获取成功")

    -- 2. 检查配置表
    if not MyUI_Checkboxes then
        print("[警告] MyUI_Checkboxes配置表不存在，创建空表")
        MyUI_Checkboxes = {}
    end

    for i, inputDef in ipairs(MyUI_Checkboxes or {}) do
        -- 3. 获取配置值
        local label = inputDef.label or "启用"
        local name = inputDef.name or "MyUICheckbox"
        local tooltip = inputDef.tooltip or "启用或禁用此功能"
        local startY = -150
        local startX = 20

        print(string.format("CheckBox配置 - 名称:%s, 标签:%s, 提示:%s", name, label, tooltip))

        -- 4. 创建CheckBox
        print("正在创建CheckBox框架...")
        local checkbox = CreateFrame("CheckButton", name, frame, "UICheckButtonTemplate")
        if not checkbox then
            print("[错误] 无法创建CheckBox框架")
            return nil
        end
        print("CheckBox框架创建成功")

        -- 5. 设置位置
        print("设置CheckBox位置: TOPLEFT, 20, -40")
        
        checkbox:SetPoint("TOPLEFT", frame, "TOPLEFT", startX, startY)
        

        -- 6. 设置文本标签
        print("设置CheckBox文本标签...")
        local checkboxText = _G[name .. "Text"]
        if checkboxText then
            -- 使用模板创建的文本标签
            print("找到模板创建的文本标签")
            checkboxText:SetPoint("LEFT", checkbox, "RIGHT", 5, 0)
            checkboxText:SetText(label)
            print("文本标签设置完成: " .. label)
        else
            -- 模板未创建文本标签，手动创建
            print("[警告] 模板未创建文本标签，手动创建")
            checkboxText = checkbox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            if checkboxText then
                checkboxText:SetPoint("LEFT", checkbox, "RIGHT", 5, 0)
                checkboxText:SetText(label)
                print("手动创建文本标签成功: " .. label)
            else
                print("[错误] 无法创建文本标签")
            end
        end

        -- 7. 设置提示信息（修正原代码问题）
        print("设置提示信息...")
        if tooltip and tooltip ~= "" then
            print("设置提示文本: " .. tooltip)
            checkbox:SetScript("OnEnter", function(self)
                print("鼠标进入CheckBox")
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(tooltip)
                GameTooltip:Show()
            end)
            checkbox:SetScript("OnLeave", function()
                print("鼠标离开CheckBox")
                GameTooltip:Hide()
            end)
        else
            print("无提示信息需要设置")
        end

        -- 8. 添加点击事件用于调试
        print("添加点击事件...")
        checkbox:SetScript("OnClick", function()
            local checked = self:GetChecked()
            print(string.format("CheckBox点击 - 名称:%s, 状态:%s", name, checked and "选中" or "未选中"))
        end)

        -- 9. 添加显示/隐藏日志
        checkbox:SetScript("OnShow", function()
            print("CheckBox显示: " .. name)
        end)

        checkbox:SetScript("OnHide", function()
            print("CheckBox隐藏: " .. name)
        end)

        -- 10. 将CheckBox存储到主框架中
        frame[inputDef.label].checkbox = checkbox
        print("CheckBox存储到frame.checkbox")
        startX = startX + 50 -- 更新X位置以防重叠

        print("<<< MyUI:CheckBox创建完成")
    end

end

-- 创建按钮
function MyUI:CreateButtons()
    local frame = self.mainFrame
    local buttonWidth = 80  -- 按钮宽度
    local buttonHeight = MyUI_Config.buttons.height or 25
    local buttonSpacing = MyUI_Config.buttons.spacing or 10
    

    -- 计算所有按钮总宽度
    local totalWidth = 0
    for i, btnDef in ipairs(MyUI.Buttons or {}) do
        totalWidth = totalWidth + (btnDef.width or buttonWidth)
        if i < MyUI.Buttons then
            totalWidth = totalWidth + buttonSpacing
            print(string.format("CreateButtons - 名称:%s, 标签:%s", btnDef.text, btnDef.label))
        end
    end

    -- 从中心点开始计算起始位置
    local startX = 0
    local currentX = startX

    for i, btnDef in ipairs(MyUI.Buttons or {}) do
        local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        local btnWidth = btnDef.width or buttonWidth
        button:SetSize(btnWidth, buttonHeight)
        button:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", currentX + btnWidth/2, 20)
        button:SetText(btnDef.text)

        -- 提示信息
        if btnDef.tooltip then
            button:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText(btnDef.tooltip)
                GameTooltip:Show()
            end)
            button:SetScript("OnLeave", function()
                GameTooltip:Hide()
            end)
        end

        -- 存储引用
        frame[btnDef.name] = button

        -- 计算下一个按钮的位置
        currentX = currentX + btnWidth + buttonSpacing
    end
end

-- 初始化插件
function MyUI:Initialize()
    -- 创建UI
    self:CreateUI()

    -- 注册Slash命令
    self:RegisterSlashCommands()

    -- 保存变量声明
    self:DeclareSavedVariables()

    print(self.L["MyUI 插件已加载！输入 /myui 打开界面。"])
end

-- 注册Slash命令
function MyUI:RegisterSlashCommands()
    SLASH_MYUI1 = "/myui"
    SlashCmdList["MYUI"] = function(msg)
        if msg == "hide" then
            self.mainFrame:Hide()
        elseif msg == "show" then
            self.mainFrame:Show()
        elseif msg == "reset" then
            self.mainFrame:ClearAllPoints()
            self.mainFrame:SetPoint(unpack(self.Config.frame.position))
        elseif msg == "test" then
            print("测试命令: MyUI 插件运行正常")
        else
            if self.mainFrame:IsShown() then
                self.mainFrame:Hide()
            else
                self.mainFrame:Show()
            end
        end
    end
end

-- 声明保存变量
function MyUI:DeclareSavedVariables()
    -- 这会在下次登录时自动加载
    MyUISavedConfig = MyUISavedConfig or {}
end

-- 事件处理
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addon)
    if addon == addonName then
        MyUI:Initialize()
    end
end)

-- 全局访问
_G.MyUI = MyUI