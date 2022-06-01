--사이돌 아상블라쥬
local m=81251060
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(24094653)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_DICE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetTarget(cm.tar2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(0x10)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.co3)
	e3:SetTarget(cm.tar3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
cm.toss_dice=true
function cm.tfil21(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_FAIRY) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.tfil22(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function cm.tfil23(c)
	return cm.tfil22(c) and c:IsFaceup()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND)
		local res=Duel.IsExistingMatchingCard(cm.tfil21,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local mg=mg1:Clone()
			local exg=Duel.GetMatchingGroup(cm.tfil22,tp,LOCATION_DECK,0,nil)
			mg:Merge(exg)
			res=Duel.IsExistingMatchingCard(cm.tfil21,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		end
		if not res then
			local mg=mg1:Clone()
			local exg=Duel.GetMatchingGroup(cm.tfil22,tp,LOCATION_MZONE,0,nil)
			mg:Merge(exg)
			res=Duel.IsExistingMatchingCard(cm.tfil21,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		end
		if not res then
			local mg=mg1:Clone()
			local exg=Duel.GetMatchingGroup(cm.tfil22,tp,LOCATION_GRAVE,0,nil)
			mg:Merge(exg)
			res=Duel.IsExistingMatchingCard(cm.tfil21,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		end
		if not res then
			local mg=mg1:Clone()
			local exg=Duel.GetMatchingGroup(cm.tfil23,tp,0,LOCATION_MZONE,nil)
			mg:Merge(exg)
			res=Duel.IsExistingMatchingCard(cm.tfil21,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		end
		if not res then
			local mg=mg1:Clone()
			local exg=Duel.GetMatchingGroup(cm.tfil22,tp,0,LOCATION_GRAVE,nil)
			mg:Merge(exg)
			res=Duel.IsExistingMatchingCard(cm.tfil21,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		end
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.tfil21,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.ofil21(c,e)
	return c:IsLocation(LOCATION_HAND) and not c:IsImmuneToEffect(e)
end
function cm.ofil22(c,e)
	return cm.tfil22(c) and not c:IsImmuneToEffect(e)
end
function cm.ofil23(c,e)
	return cm.tfil23(c) and not c:IsImmuneToEffect(e)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.ofil21,nil,e)
	local dc=Duel.TossDice(tp,1)
	if dc==1 then
		local exg=Duel.GetMatchingGroup(cm.ofil22,tp,LOCATION_DECK,0,nil,e)
		mg1:Merge(exg)
	elseif dc==2 then
		local exg=Duel.GetMatchingGroup(cm.ofil22,tp,LOCATION_MZONE,0,nil,e)
		mg1:Merge(exg)
	elseif dc==3 then
		local exg=Duel.GetMatchingGroup(cm.ofil22,tp,LOCATION_GRAVE,0,nil,e)
		mg1:Merge(exg)
	elseif dc==4 then
		local exg=Duel.GetMatchingGroup(cm.ofil23,tp,0,LOCATION_MZONE,nil,e)
		mg1:Merge(exg)
	elseif dc==5 then
		local exg=Duel.GetMatchingGroup(cm.ofil22,tp,0,LOCATION_GRAVE,nil,e)
		mg1:Merge(exg)
	end
	local sg1=Duel.GetMatchingGroup(cm.tfil21,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=GetMatchingGroup(cm.tfil21,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if #sg1>0 or (sg2~=nil and #sg2>0) then
		local sg=sg1:Clone()
		if sg2 then
			sg:Merge(sg2)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			local gmat=mat1:Filter(Card.IsLocation,nil,LOCATION_HAND)
			mat1:Sub(gmat)
			Duel.SendtoGrave(gmat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function cm.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function cm.tfil3(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc82) and c:IsType(0x1) and c:IsLevelBelow(4)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil3,tp,0x10,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x10)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tfil3,tp,0x10,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
