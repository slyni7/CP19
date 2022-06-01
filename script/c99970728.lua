--[ Refined Spellstone ]
local m=99970728
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	YuL.Equip(c,nil,aux.FBF(Card.IsSetCard,0xd6b))

	--효과 부여: 무효화
	local e1=MakeEff(c,"F","M")
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSummonType,SUMT_SP))
	e1:SetCode(EFFECT_DISABLE)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e0:SetRange(LOCATION_SZONE)
	e0:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e0:SetTarget(cm.eqtar)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
	
	--효과 부여: 장착
	local e3=MakeEff(c,"I","M")
	e3:SetD(m,0)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCL(1)
	WriteEff(e3,3,"NTO")
	aux.AddEREquipLimit(c,cm.con3,function(ec,_,tp) return ec:IsControler(1-tp) end,cm.op3op,e3)
	local e2=e0:Clone()
	e2:SetLabelObject(e3)
	c:RegisterEffect(e2)
	
	--드로우
	local e4=MakeEff(c,"STo")
	e4:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e4:SetProperty(spinel.delay)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(aux.PreOnfield)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
	
end

--효과 부여
function cm.eqtar(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function cm.eqfilter(c)
	return c:GetFlagEffect(m)~=0 
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetEquipGroup():Filter(cm.eqfilter,nil)
	return #g==0
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function cm.op3op(c,e,tp,tc)
	if not aux.EquipByEffectAndLimitRegister(c,e,tp,tc,m) then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(700)
	tc:RegisterEffect(e2)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		cm.equipop(c,e,tp,tc)
	end
end

--드로우
function cm.tar4fil(c)
	return c:IsSetCard(0xd6c) and c:IsAbleToGrave()
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(cm.tar4fil,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,cm.tar4fil,1,1,REASON_EFFECT)~=0 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
