--아포칼립스트 히나아우
local m=18453316
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	local e1=MakeEff(c,"F","H")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"SC")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STo")
	e3:SetCode(m)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCountLimit(1,m+1)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","M")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_BOTH_SIDE)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetCountLimit(1,m+2)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
end
function cm.nfil1(c,tp)
	return c:IsReleasable() and Duel.GetMZoneCount(1-tp,c,tp)>0
end
function cm.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local b=Duel.GetLocCount(tp,"M")>0 and Duel.GetLocCount(1-tp,"M")>0 and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0x2ee,0x4011,1300,1600,5,RACE_CYBERSE,ATTRIBUTE_WIND)
	return b or Duel.IEMCard(cm.nfil1,tp,0,"M",1,nil,tp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local b=Duel.GetLocCount(tp,"M")>0 and Duel.GetLocCount(1-tp,"M")>0 and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0x2ee,0x4011,1300,1600,5,RACE_CYBERSE,ATTRIBUTE_WIND)
	local min=b and 0 or 1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SMCard(tp,cm.nfil1,tp,0,"M",min,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.Release(tc,REASON_COST)
	else
		local token=Duel.CreateToken(tp,m+1)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=c:GetOwner()
	Duel.RaiseSingleEvent(c,m,e,0,op,op,0)
end
function cm.tfil3(c)
	return c:IsSetCard(0x2ee) and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil3,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOwner()==tp
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local b=fc and fc:IsHasEffect(18453321,tp) and fc:IsAbleToHandAsCost()
	if chk==0 then
		return c:IsAbleToHandAsCost() or b
	end
	if b and (not c:IsAbleToHandAsCost() or Duel.SelectYesNo(tp,aux.Stringid(18453321,0))) then
		local te=fc:IsHasEffect(18453321,tp)
		te:UseCountLimit(tp)
		Duel.SendtoHand(fc,nil,REASON_COST)
	else
		Duel.SendtoHand(c,nil,REASON_COST)
	end
end
function cm.tfil4(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(1-tp) and cm.tfil4(chkc) and chkc~=c
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil4,tp,"O","O",1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.STarget(tp,cm.tfil4,tp,"O","O",1,1,c)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end