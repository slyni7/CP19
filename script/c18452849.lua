--헤븐 다크사이트 -다미-
local m=18452849
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"F","MG")
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTargetRange(LSTN("M"),0)
	e1:SetValue(cm.val1)
	e1:SetTarget(cm.tar1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,m)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","H")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,m)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"I","M")
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_DESTROY)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
end
function cm.val1(e,c)
	return c:GetAttack()+300
end
function cm.tar1(e,c)
	return c:GetBaseAttack()==0 and c:IsType(TYPE_TUNER)
end
function cm.tfil2(c,e,tp)
	return c:IsAttack(0) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and chkc~=c and cm.tfil2(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IETarget(cm.tfil2,tp,"G",0,1,c,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.tfil2,tp,"G",0,1,1,c,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.cfil3(c)
	return c:IsAttack(0) and c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(cm.cfil3,tp,"G",0,1,nil) and c:IsDiscardable()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SMCard(tp,cm.cfil3,tp,"G",0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tfil3(c)
	return c:IsType(TYPE_LINK) and c:IsFaceup()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsLoc("M") and cm.tfil3(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil3,tp,0,"M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.STarget(tp,cm.tfil3,tp,0,"M",1,1,nil)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=MakeEff(c,"F","M")
		e2:SetCode(EFFECT_MUST_USE_MZONE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetTarget(1,0)
		e2:SetValue(cm.oval32)
		tc:RegisterEffect(e2)
	end
end
function cm.oval32(e)
	local c=e:GetHandler()
	return 0x7f007f & ~c:GetLinkedZone()
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fc=Duel.GetFieldCard(tp,LSTN("F"),0)
	if fc and fc:IsFaceup() and fc:IsSetCard(0x2d9) then
		return c:GetFlagEffect(m)<2
	else
		return c:GetFlagEffect(m)<1
	end
end
function cm.cfil4(c,tp)
	return c:GetBaseAttack()==0 and Duel.IETarget(aux.TRUE,tp,0,"O",1,c)
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	e:SetLabel(1)
	if chk==0 then
		return Duel.CheckReleaseGroup(tp,cm.cfil4,1,c,tp)
	end
	local g=Duel.SelectReleaseGroup(tp,cm.cfil4,1,1,c,tp)
	Duel.Release(g,REASON_COST)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsOnField()
	end
	local res=e:GetLabel()>0 or Duel.IETarget(aux.TRUE,tp,0,"O",1,nil)
	if chk==0 then
		e:SetLabel(0)
		return res
	end
	c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,aux.TRUE,tp,0,"O",1,1,nil)
	Duel.SOI(0,CATEGORY_DESTORY,g,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end