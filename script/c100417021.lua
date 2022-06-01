--엑소시스터 아멘드
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
end
s.listed_series={0x2ff}
function s.nfil1(c)
	return c:IsSummonLocation(LSTN("G"))
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp or Duel.IEMCard(s.nfil1,tp,0,"M",1,nil)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,800)
	end
	Duel.PayLPCost(tp,800)
end
function s.tfil11(c,e,tp)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(c),tp,nil,nil,REASON_XYZ)
	return #pg<=1 and Duel.IEMCard(s.tfil12,tp,"E",0,1,nil,e,tp,c,pg)
end
function s.tfil12(c,e,tp,tc,pg)
	return c:IsSetCard(0x2ff) and tc:IsCanBeXyzMaterial(c,tp)
		and (#pg<=0 or pg:IsContains(tc)) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IETarget(s.tfil11,tp,"M",0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then
		return
	end
	local pg=aux.GetMustBeMaterialGroup(tp,Group.FromCards(tc),tp,nil,nil,REASON_XYZ)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,s.tfil12,tp,"E",0,1,1,nil,e,tp,tc,pg)
	local sc=g:GetFirst()
	if sc then
		local mg=c:GetOverlayGroup()
		if #mg~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end