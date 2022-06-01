--举府胶牡甸
local m=18453151
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_MULTIPLE_FUSION_MATERIAL)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOGRAVE)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e3:SetCountLimit(1)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
end
cm.square_mana={ATTRIBUTE_FIRE,ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT,0x0,0x0,ATTRIBUTE_WIND,ATTRIBUTE_WATER,ATTRIBUTE_DARK}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.mat_group_check(g)
	local st=cm.square_mana
	return aux.IsFitSquare(g,st)
end
function cm.val1(e,c)
	if c:IsCustomType(CUSTOMTYPE_SQUARE) then
		return 2
	end
	return 1
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	e:SetLabel(c:GetLocation())
	return rc:IsType(TYPE_FUSION) and rc:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsLoc("GR")
end
function cm.tfil2(c)
	return c:IsSetCard("举府胶") and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and not c:IsCode(m)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,1,tp,"D")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTR(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabel(e:GetLabel())
	e1:SetValue(cm.oval21)
	Duel.RegisterEffect(e1,tp)
end
function cm.oval21(e,re,tp)
	local loc=e:GetLabel()
	local rc=re:GetHandler()
	return re:GetActivateLocation()==loc and rc:IsCode(m) and re==cm.eff_ct[rc][1]
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_RITUAL) and Duel.GetCurrentPhase()&PHASE_MAIN1+PHASE_MAIN2>0
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and chkc:IsFaceup()
	end
	if chk==0 then
		return Duel.IETarget(Card.IsFaceup,tp,"M","M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.STarget(tp,Card.IsFaceup,tp,"M","M",1,1,nil)
	Duel.SOI(0,CATEGORY_DESTROY,g,0,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local off=1
		local ops={}
		local opval={}
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
		if tc:IsFaceup() and tc:GetAttack()>0 then
			ops[off]=aux.Stringid(m,1)
			opval[off-1]=2
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			Duel.Destroy(tc,REASON_EFFECT)
		elseif opval[op]==2 then
			Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
		end
	end
end