--Imaginary Beast
local m=99970270
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
	--Imaginary Beast
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.ImaginaryBeastTarget)
	e2:SetOperation(cm.ImaginaryBeastOperation)
	c:RegisterEffect(e2)
	
		--Imaginary Beast: Wolf
			--표시 형식 변경
			local ew1=Effect.CreateEffect(c)
			ew1:SetType(EFFECT_TYPE_EQUIP)
			ew1:SetCode(EFFECT_SET_POSITION)
			ew1:SetValue(POS_FACEUP_DEFENSE)
			ew1:SetCondition(cm.Wolfcon)
			c:RegisterEffect(ew1)
			--수비력 증가
			local ew2=Effect.CreateEffect(c)
			ew2:SetType(EFFECT_TYPE_EQUIP)
			ew2:SetCode(EFFECT_UPDATE_DEFENSE)
			ew2:SetValue(1000)
			ew2:SetCondition(cm.Wolfcon)
			c:RegisterEffect(ew2)
			--수비 공격
			local ew3=Effect.CreateEffect(c)
			ew3:SetType(EFFECT_TYPE_EQUIP)
			ew3:SetCode(EFFECT_DEFENSE_ATTACK)
			ew3:SetValue(1)
			ew3:SetCondition(cm.Wolfcon)
			c:RegisterEffect(ew3)
			
		--Imaginary Beast: Dragon
			--remove
			local ed1=Effect.CreateEffect(c)
			ed1:SetCategory(CATEGORY_REMOVE)
			ed1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
			ed1:SetProperty(EFFECT_FLAG_CARD_TARGET)
			ed1:SetCode(EVENT_BATTLE_DAMAGE)
			ed1:SetRange(LOCATION_SZONE)
			ed1:SetCondition(cm.Dragoncon)
			ed1:SetTarget(cm.rmtg)
			ed1:SetOperation(cm.rmop)
			c:RegisterEffect(ed1)
			
		--Imaginary Beast: Gryphon
			--공격력 증가
			local eg1=Effect.CreateEffect(c)
			eg1:SetType(EFFECT_TYPE_EQUIP)
			eg1:SetCode(EFFECT_UPDATE_ATTACK)
			eg1:SetValue(600)
			eg1:SetCondition(cm.Gryphoncon)
			c:RegisterEffect(eg1)
			--다중 공격
			local eg2=Effect.CreateEffect(c)
			eg2:SetType(EFFECT_TYPE_EQUIP)
			eg2:SetCode(EFFECT_ATTACK_ALL)
			eg2:SetValue(1)
			eg2:SetCondition(cm.Gryphoncon)
			c:RegisterEffect(eg2)
	
end

--장착
function cm.eqfilter(c)
	return c:IsFaceup() and (c:IsCode(99970261) or c:IsSetCard(0xe02))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.eqfilter(chkc) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) 
		and Duel.IsExistingTarget(cm.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(cm.eqlimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function cm.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() or e:GetHandler():GetEquipTarget()==c
end

--Imaginary Beast
function cm.ImaginaryBeastTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	e:SetLabel(Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))+1)
end
function cm.ImaginaryBeastOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,e:GetLabel())
	end
end

--Imaginary Beast: Wolf
function cm.Wolfcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():GetFlagEffectLabel(m)==1 or e:GetHandler():GetFlagEffectLabel(m)==2)
end

--Imaginary Beast: Dragon
function cm.Dragoncon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():GetFlagEffectLabel(m)==1 or e:GetHandler():GetFlagEffectLabel(m)==3) and ep~=tp and eg:GetFirst()==e:GetHandler():GetEquipTarget()
end
function cm.filter(c)
	return c:IsAbleToRemove()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_GRAVE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end

--Imaginary Beast: Gryphon
function cm.Gryphoncon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():GetFlagEffectLabel(m)==2 or e:GetHandler():GetFlagEffectLabel(m)==3)
end
