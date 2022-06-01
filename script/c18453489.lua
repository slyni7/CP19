--미세스코드 토커
local m=18453489
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,1,1)
	local e1=MakeEff(c,"F","E")
	e1:SetCode(EFFECT_EXTRA_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(1,1)
	e1:SetOperation(cm.op1)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","M")
	e2:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S","M")
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(cm.val3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"S")
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(cm.val4)
	c:RegisterEffect(e4)
end
cm.curgroup=nil
function cm.op1(c,e,tp,sg,mg,lc,og,chk)
	return not cm.curgroup or #(sg&cm.curgroup)<2
end
function cm.val1(chk,summon_type,e,...)
	if chk==0 then
		local tp,sc=...
		if summon_type~=SUMMON_TYPE_LINK or sc~=e:GetHandler() then
			return Group.CreateGroup()
		else
			cm.curgroup=Duel.GMGroup(Card.IsType,tp,0,"M",nil,TYPE_LINK)
			cm.curgroup:KeepAlive()
			return cm.curgroup
		end
	elseif chk==2 then
		if cm.curgroup then
			cm.curgroup:DeleteGroup()
		end
		cm.curgroup=nil
	end
end
function cm.val3(e,c)
	if not c then
		return false
	end
	local tp=e:GetHandlerPlayer()
	return c:IsControler(1-tp)
end
function cm.val4(e,c)
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	if tc:IsType(TYPE_LINK) and tc:IsType(TYPE_EFFECT) then
		local code=tc:GetOriginalCode()
		c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END-RESET_TOFIELD,0)
	end
end