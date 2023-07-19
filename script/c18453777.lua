--This is my kingdom come
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSkullProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),nil,nil)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,id)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	WriteEff(e2,2,"N")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetCountLimit(1,{id,1})
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
s.custom_type=CUSTOMTYPE_SKULL
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SKULL)
end
function s.tfil1(c,e,tp)
	return (c:IsSetCard(0x45) or c:IsCustomType(CUSTOMTYPE_SKULL))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(7)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and s.tfil1(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil1,tp,"G",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,s.tfil1,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.nfil2(c,tp)
	return c:IsSummonType(SUMMON_TYPE_SKULL) and c:IsSummonPlayer(tp)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(s.nfil2,1,c,tp)
end
function s.cfil3(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_FIEND)
		and Duel.IEMCard(s.tfil3,tp,0,"M",1,c,c:GetAttack())
end
function s.tfil3(c,atk)
	return c:IsFaceup() and c:IsDefenseBelow(atk)
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckReleaseGroupCost(tp,s.cfil3,1,false,nil,nil,tp)
	end
	local g=Duel.SelectReleaseGroupCost(tp,s.cfil3,1,1,false,nil,nil,tp)
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.Release(g,REASON_COST)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local g=Duel.GMGroup(s.tfil3,tp,0,"M",nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(s.tfil3,tp,0,"M",nil,e:GetLabel())
	Duel.Destroy(g,REASON_EFFECT)
end
