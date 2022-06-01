--확산(디퓨전)
local m=122400000
local cm=_G["c"..m]
function cm.initial_effect(c)
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.tfil11(c)
	return c:IsCanBeFusionMaterial()
end
function cm.tfil12(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_DIFFUSION,tp,false,false)
end
function cm.tfil13(c,mg,sg,chkf)
	return mg:IsExists(cm.tfil14,1,nil,c,sg,chkf)
end
function cm.tfil14(c,dc,sg,chkf)
	return dc:CheckDiffusionMaterial(c,sg,chkf)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(cm.tfil11,tp,LOCATION_MZONE,0,nil)
		local sg=Duel.GetMatchingGroup(cm.tfil12,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
		local chkf=tp
		local res=sg:IsExists(cm.tfil13,1,nil,mg,sg,chkf)
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.tfil11,tp,LOCATION_MZONE,0,nil)
	local sg=Duel.GetMatchingGroup(cm.tfil12,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	local chkf=tp
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=sg:FilterSelect(tp,cm.tfil13,1,1,nil,mg,sg,chkf):GetFirst()
	if not sc then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local mc=mg:FilterSelect(tp,cm.tfil14,1,1,nil,sc,sg,chkf):GetFirst()
	local dg=sc:SelectDiffusionMaterial(tp,mc,sg,chkf)
	Duel.SendtoGrave(mc,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	Duel.BreakEffect()
	local hct=dg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
	local dct=dg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	local dc=dg:GetFirst()
	while dc do
		dc:SetMaterial(Group.FromCards(mc))
		dc=dg:GetNext()
	end
	Duel.SpecialSummon(dg,SUMMON_TYPE_DIFFUSION,tp,tp,false,false,POS_FACEUP)
	while dc do
		dc:CompleteProcedure()
		dc=dg:GetNext()
	end
	if hct>0 then
		if dct>0 then
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
		end
		Duel.Draw(tp,hct,REASON_EFFECT)
	end
end