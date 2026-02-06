-- 事件处理器模块
MyUI_EventHandlers = {}

-- 本地引用
local addonName, addonTable = ...
local MyUI = addonTable.MyUI or {}
local L = MyUI.L or {}

-- 按钮点击事件处理器
function MyUI_EventHandlers:Initialize()
    -- 绑定所有按钮事件
    self:SetupButtonEvents()
    
    -- 绑定输入框事件
    self:SetupInputEvents()
end

-- 设置按钮事件
function MyUI_EventHandlers:SetupButtonEvents()
    local frame = MyUI.mainFrame
    
    if not frame then return end
    
    -- 按钮1: 保存配置
    if frame.btnSave then
        frame.btnSave:SetScript("OnClick", function(self)
            self:SaveConfig()
        end)
        
        -- 添加方法到按钮本身
        frame.btnSave.SaveConfig = function(btn)
            MyUI_EventHandlers:OnSaveConfig()
        end
    end
    
    -- 按钮2: 加载配置
    if frame.btnLoad then
        frame.btnLoad:SetScript("OnClick", function(self)
            self:LoadConfig()
        end)
        
        frame.btnLoad.LoadConfig = function(btn)
            MyUI_EventHandlers:OnLoadConfig()
        end
    end
    
    -- 按钮3: 处理文本
    if frame.btnProcess then
        frame.btnProcess:SetScript("OnClick", function(self)
            self:ProcessText()
        end)
        
        frame.btnProcess.ProcessText = function(btn)
            MyUI_EventHandlers:OnProcessText()
        end
    end
    
    -- 按钮4: 清空所有
    if frame.btnClear then
        frame.btnClear:SetScript("OnClick", function(self)
            self:ClearAll()
        end)
        
        frame.btnClear.ClearAll = function(btn)
            MyUI_EventHandlers:OnClearAll()
        end
    end
    
    -- 按钮5: 高级选项
    if frame.btnAdvanced then
        frame.btnAdvanced:SetScript("OnClick", function(self)
            self:ToggleAdvanced()
        end)
        
        frame.btnAdvanced.ToggleAdvanced = function(btn)
            MyUI_EventHandlers:OnToggleAdvanced()
        end
    end
end

-- 设置输入框事件
function MyUI_EventHandlers:SetupInputEvents()
    local frame = MyUI.mainFrame
    
    if not frame then return end
    
    -- 输入框获得焦点事件
    if frame.inputName then
        frame.inputName:SetScript("OnEscapePressed", function(self)
            self:ClearFocus()
        end)
        
        frame.inputName:SetScript("OnEnterPressed", function(self)
            self:ClearFocus()
        end)
    end
    
    -- 数值输入框验证
    if frame.inputValue then
        frame.inputValue:SetScript("OnTextChanged", function(self)
            self:ValidateNumber()
        end)
        
        frame.inputValue.ValidateNumber = function(input)
            MyUI_EventHandlers:ValidateNumberInput(input)
        end
    end
end

-- 事件处理函数
function MyUI_EventHandlers:OnSaveConfig()
    print(L["正在保存配置..."])
    
    -- 收集所有输入框的值
    local config = {}
    
    if MyUI.mainFrame.inputName then
        config.name = MyUI.mainFrame.inputName:GetText()
    end
    
    if MyUI.mainFrame.inputValue then
        config.value = tonumber(MyUI.mainFrame.inputValue:GetText()) or 0
    end
    
    if MyUI.mainFrame.inputMultiLine then
        config.note = MyUI.mainFrame.inputMultiLine:GetText()
    end
    
    -- 保存到 SavedVariables (需要先声明)
    if MyUISavedConfig then
        MyUISavedConfig = config
    end
    
    -- 显示保存成功的消息
    self:ShowMessage("配置已保存！", MyUI_Config.colors.success)
    
    print(L["配置保存完成"])
    
    -- 触发保存完成事件
    self:FireEvent("CONFIG_SAVED", config)
end

function MyUI_EventHandlers:OnLoadConfig()
    print(L["正在加载配置..."])
    
    -- 从 SavedVariables 加载
    if MyUISavedConfig then
        if MyUI.mainFrame.inputName then
            MyUI.mainFrame.inputName:SetText(MyUISavedConfig.name or "")
        end
        
        if MyUI.mainFrame.inputValue then
            MyUI.mainFrame.inputValue:SetText(tostring(MyUISavedConfig.value or 100))
        end
        
        if MyUI.mainFrame.inputMultiLine then
            MyUI.mainFrame.inputMultiLine:SetText(MyUISavedConfig.note or "")
        end
        
        self:ShowMessage("配置已加载！", MyUI_Config.colors.info)
    else
        self:ShowMessage("没有找到保存的配置", MyUI_Config.colors.warning)
    end
    
    print(L["配置加载完成"])
    
    -- 触发加载完成事件
    self:FireEvent("CONFIG_LOADED")
end

function MyUI_EventHandlers:OnProcessText()
    print(L["正在处理文本..."])
    
    local name = MyUI.mainFrame.inputName and MyUI.mainFrame.inputName:GetText() or ""
    local value = MyUI.mainFrame.inputValue and tonumber(MyUI.mainFrame.inputValue:GetText()) or 0
    local note = MyUI.mainFrame.inputMultiLine and MyUI.mainFrame.inputMultiLine:GetText() or ""
    
    if name == "" then
        self:ShowMessage("请输入名称", MyUI_Config.colors.warning)
        return
    end
    
    -- 示例处理逻辑
    local processed = string.format("名称: %s, 数值: %d, 备注长度: %d", 
        name, value, string.len(note))
    
    print(L["处理结果: "] .. processed)
    self:ShowMessage("处理完成: " .. processed, MyUI_Config.colors.success)
    
    -- 触发处理完成事件
    self:FireEvent("TEXT_PROCESSED", {name = name, value = value, note = note})
end

function MyUI_EventHandlers:OnClearAll()
    print(L["正在清空所有输入框..."])
    
    -- 清空所有输入框
    if MyUI.mainFrame.inputName then
        MyUI.mainFrame.inputName:SetText("")
    end
    
    if MyUI.mainFrame.inputValue then
        MyUI.mainFrame.inputValue:SetText("")
    end
    
    if MyUI.mainFrame.inputMultiLine then
        MyUI.mainFrame.inputMultiLine:SetText("")
    end
    
    self:ShowMessage("已清空所有输入框", MyUI_Config.colors.info)
    
    -- 触发清空事件
    self:FireEvent("INPUTS_CLEARED")
end

function MyUI_EventHandlers:OnToggleAdvanced()
    print(L["切换高级选项"])
    
    -- 这里可以打开一个高级选项面板
    self:ShowMessage("高级选项功能开发中...", MyUI_Config.colors.info)
    
    -- 触发高级选项事件
    self:FireEvent("ADVANCED_TOGGLED")
end

-- 输入验证函数
function MyUI_EventHandlers:ValidateNumberInput(input)
    local text = input:GetText()
    local num = tonumber(text)
    
    if text ~= "" and not num then
        -- 不是有效数字，显示警告
        self:ShowMessage("请输入有效的数字", MyUI_Config.colors.warning, 2)
        
        -- 清除无效输入
        input:SetText("")
    elseif num and (num < 0 or num > 9999) then
        -- 数字超出范围
        self:ShowMessage("数字范围应在 0-9999 之间", MyUI_Config.colors.warning, 2)
        
        -- 限制到有效范围
        if num < 0 then
            input:SetText("0")
        else
            input:SetText("9999")
        end
    end
end

-- 显示消息函数
function MyUI_EventHandlers:ShowMessage(text, color, duration)
    duration = duration or 3
    
    -- 创建消息框架（如果不存在）
    if not MyUI.messageFrame then
        MyUI.messageFrame = CreateFrame("Frame", nil, UIParent)
        MyUI.messageFrame:SetSize(300, 50)
        MyUI.messageFrame:SetPoint("TOP", UIParent, "TOP", 0, -100)
        MyUI.messageFrame:Hide()
        
        MyUI.messageFrame.bg = MyUI.messageFrame:CreateTexture(nil, "BACKGROUND")
        MyUI.messageFrame.bg:SetAllPoints()
        MyUI.messageFrame.bg:SetColorTexture(0, 0, 0, 0.7)
        
        MyUI.messageFrame.text = MyUI.messageFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        MyUI.messageFrame.text:SetPoint("CENTER")
        MyUI.messageFrame.text:SetJustifyH("CENTER")
    end
    
    -- 设置消息
    MyUI.messageFrame.text:SetText(text)
    MyUI.messageFrame.text:SetTextColor(unpack(color or {1, 1, 1, 1}))
    
    -- 显示消息
    MyUI.messageFrame:Show()
    
    -- 定时隐藏
    C_Timer.After(duration, function()
        if MyUI.messageFrame then
            MyUI.messageFrame:Hide()
        end
    end)
end

-- 事件系统
MyUI_EventHandlers.events = {}

function MyUI_EventHandlers:RegisterEvent(event, handler)
    if not self.events[event] then
        self.events[event] = {}
    end
    table.insert(self.events[event], handler)
end

function MyUI_EventHandlers:UnregisterEvent(event, handler)
    if self.events[event] then
        for i, h in ipairs(self.events[event]) do
            if h == handler then
                table.remove(self.events[event], i)
                break
            end
        end
    end
end

function MyUI_EventHandlers:FireEvent(event, ...)
    if self.events[event] then
        for _, handler in ipairs(self.events[event]) do
            handler(...)
        end
    end
end

-- 导出到全局
addonTable.EventHandlers = MyUI_EventHandlers