--레이니데이 아이린
local m=99000126
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Activate
	local ea=Effect.CreateEffect(c)
	ea:SetCategory(CATEGORY_SPECIAL_SUMMON)
	ea:SetType(EFFECT_TYPE_IGNITION)
	ea:SetRange(LOCATION_HAND)
	ea:SetCondition(cm.handcon)
	ea:SetTarget(cm.target)
	ea:SetOperation(cm.activate)
	c:RegisterEffect(ea)
	--Activate (Grave)
	local eb=ea:Clone()
	eb:SetRange(LOCATION_GRAVE)
	eb:SetCondition(cm.gravecon)
	eb:SetTarget(cm.gravetarget)
	c:RegisterEffect(eb)
	--Activate (Quick, Hand)
	local ec=ea:Clone()
	ec:SetType(EFFECT_TYPE_QUICK_O)
	ec:SetCode(EVENT_FREE_CHAIN)
	ec:SetCondition(cm.quickremovedcon)
	c:RegisterEffect(ec)
	--Activate (Quick, Grave)
	local ed=eb:Clone()
	ed:SetType(EFFECT_TYPE_QUICK_O)
	ed:SetCode(EVENT_FREE_CHAIN)
	ed:SetCondition(cm.quickgravecon)
	ed:SetTarget(cm.gravetarget)
	c:RegisterEffect(ed)
	--Activate (Quick, Removed)
	local ee=ea:Clone()
	ee:SetType(EFFECT_TYPE_QUICK_O)
	ee:SetRange(LOCATION_REMOVED)
	ee:SetCode(EVENT_FREE_CHAIN)
	ee:SetCondition(cm.quickremovedcon)
	ee:SetTarget(cm.removedtarget)
	c:RegisterEffect(ee)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.descon)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(cm.condition)
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)
end
cm.RCheckAdditional=nil
cm.RGCheckAdditional=nil
function cm.handcon(e)
	return not e:GetHandler():IsHasEffect(99000128)
end
function cm.gravecon(e)
	return e:GetHandler():IsHasEffect(99000129) and not e:GetHandler():IsHasEffect(99000128)
end
function cm.quickremovedcon(e)
	return e:GetHandler():IsHasEffect(99000128)
end
function cm.quickgravecon(e)
	return e:GetHandler():IsHasEffect(99000128) and e:GetHandler():IsHasEffect(99000129)
end
function cm.RitualCheck(g,tp,c,lv)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetRitualLevel,lv,c) and Duel.GetMZoneCount(tp,g,tp)>0 and (not c.mat_group_check or c.mat_group_check(g,tp))
		and (not cm.RCheckAdditional or cm.RCheckAdditional(tp,g,c))
end
function cm.RitualCheckAdditional(c,lv)
	return	function(g,ec)
		if ec then
			return (not cm.RGCheckAdditional or cm.RGCheckAdditional(g,ec)) and g:GetSum(cm.RitualCheckAdditionalLevel,c)-cm.RitualCheckAdditionalLevel(ec,c)<=lv
		else
			return not cm.RGCheckAdditional or cm.RGCheckAdditional(g)
		end
	end
end
function cm.RitualCheckAdditionalLevel(c,rc)
	local raw_level=c:GetRitualLevel(rc)
	local lv1=raw_level&0xffff
	local lv2=raw_level>>16
	if lv2>0 then
		return math.min(lv1,lv2)
	else
		return lv1
	end
end
function cm.RitualExtraFilter(c)
	return c:IsSetCard(0xc21) and c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function cm.RitualUltimateFilter(c,e,tp,m1,m2,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	mg:RemoveCard(c)
	local lv=c:GetLevel()
	cm.GCheckAdditional=cm.RitualCheckAdditional(c,lv)
	local res=mg:CheckSubGroup(cm.RitualCheck,1,lv,tp,c,lv)
	cm.GCheckAdditional=nil
	return res
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local exg=Duel.GetMatchingGroup(cm.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil)
		return Duel.IsExistingMatchingCard(cm.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,e,tp,mg,exg,true) and e:GetHandler():GetFlagEffect(m+10000)==0
	end
	e:GetHandler():RegisterFlagEffect(m+10000,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	if exg~=0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local exg=Duel.GetMatchingGroup(cm.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=e:GetHandler()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if exg then
			mg:Merge(exg)
		end
		mg:RemoveCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local lv=tc:GetLevel()
		cm.GCheckAdditional=cm.RitualCheckAdditional(tc,lv)
		local mat=mg:SelectSubGroup(tp,cm.RitualCheck,false,1,lv,tp,tc,lv)
		cm.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function cm.gravetarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local exg=Duel.GetMatchingGroup(cm.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil)
		return Duel.IsExistingMatchingCard(cm.RitualUltimateFilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg,exg,true) and e:GetHandler():GetFlagEffect(m+10000)==0
	end
	e:GetHandler():RegisterFlagEffect(m+10000,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	if exg~=0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
	end
end
function cm.removedtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local exg=Duel.GetMatchingGroup(cm.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil)
		return Duel.IsExistingMatchingCard(cm.RitualUltimateFilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,mg,exg,true) and e:GetHandler():GetFlagEffect(m+10000)==0
	end
	e:GetHandler():RegisterFlagEffect(m+10000,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
	if exg~=0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=3 then
		local g2=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g2:RandomSelect(1-tp,1)
			Duel.HintSelection(sg)
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() 
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end