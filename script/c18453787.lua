--데몬 소환 프리릴리즈
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableReverseDualAttribute(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetD(id,0)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.tar1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e3:SetCountLimit(1)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
s.listed_names={70781052}
function s.nfil1(c)
	return c:IsCode(70781052) and c:IsReleasable()
end
function s.con1(e,c,minc)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return minc==0 and c:GetLevel()>4 and Duel.GetLocCount(tp,"M")>0
		and Duel.IEMCard(s.nfil1,tp,"D",0,1,nil)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SMCard(tp,s.nfil1,tp,"D",0,0,1,nil)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then
		return
	end
	Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
	g:DeleteGroup()
end
function s.tfil2(c)
	return c:IsSetCard(0x45) and c:IsType(TYPE_NORMAL) and c:IsAbleToHand()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.ofun2(g)
	return g:GetClassCount(Card.GetLevel)==1 and g:GetClassCount(Card.GetCode)==#g
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(s.tfil2,tp,"D",0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,s.ofun2,false,1,2)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function s.cfil3(c,tp)
	return c:IsCode(70781052) and c:IsAbleToDeckAsCost() and (c:IsLoc("H") or c:IsFaceup())
		and Duel.GetMZoneCount(tp,c,tp)>0 and Duel.GetMZoneCount(1-tp,c,tp)>0
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.cfil3,tp,"HO",0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SMCard(tp,s.cfil3,tp,"HO",0,1,1,nil,tp)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanSpecialSummonMonster(tp,18453783,0x2045,0x4011,2500,1200,6,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE)
			and Duel.IsPlayerCanSpecialSummonMonster(tp,18453783,0x2045,0x4011,2500,1200,6,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,1-tp)
	end
	Duel.SOI(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")>0 and Duel.GetLocCount(1-tp,"M")>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18453783,0x2045,0x4011,2500,1200,6,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18453783,0x2045,0x4011,2500,1200,6,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,1-tp) then
		local t1=Duel.CreateToken(tp,18453783)
		local t2=Duel.CreateToken(tp,18453783)
		Duel.SpecialSummonStep(t1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		Duel.SpecialSummonStep(t2,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
		Duel.SpecialSummonComplete()
	end
end
