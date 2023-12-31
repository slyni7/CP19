--청설백야
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT),2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.tar1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(s.con3)
	c:RegisterEffect(e3)
	local fusparams = {matfilter=Fusion.InHandMat(aux.TRUE),extrafil=s.extramat,extraop=s.extraop,gc=Fusion.ForcedHandler,extratg=s.extratarget}
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(function(e) return Duel.GetCurrentPhase()~=PHASE_DAMAGE and e:GetHandler():IsReason(REASON_EFFECT) end)
	e2:SetTarget(Fusion.SummonEffTG(fusparams))
	e2:SetOperation(Fusion.SummonEffOP(fusparams))
	c:RegisterEffect(e2)
end
function s.fcheck(tp,sg,fc)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>#sg
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>=#sg and Duel.GetLocationCountFromEx(tp,tp,fc,nil))
end
function s.extramat(e,tp,mg)
	return Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,0,tp,false,false),s.fcheck
end
function s.extratarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.extraop(e,tc,tp,sg)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	sg:Clear()
end
function s.nfil1(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IEMCard(s.nfil1,tp,"G",0,1,nil)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(s.nfil1,tp,"G",0,1,nil)
end
function s.tfil1(c,dd)
	return dd or c:IsAbleToGrave()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField()
	end
	local dd=Duel.IsPlayerCanDiscardDeck(tp,3)
	if chk==0 then
		return Duel.IETarget(s.tfil1,tp,"O","O",1,nil,dd)
	end
	local g=Duel.STarget(tp,s.tfil1,tp,"O","O",1,1,nil,dd)
	Duel.SPOI(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SPOI(0,CATEGORY_DECKDES,nil,1,tp,3)
end
function s.ofil1(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local dd=Duel.IsPlayerCanDiscardDeck(tp,3)
	local tc=Duel.GetFirstTarget()
	local ct=1
	if Duel.IEMCard(s.ofil1,tp,"G",0,1,nil) then
		ct=2
	end
	local used=0
	if tc:IsRelateToEffect(e) and (not dd or Duel.SelectYesNo(tp,aux.Stringid(id,0))) then
		used=used+1
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	if used<ct and dd and (used==0 or Duel.SelectYesNo(tp,aux.Stringid(id,1))) then
		Duel.DiscardDeck(tp,3,REASON_EFFECT)
	end
end