--이렇게 가까이에서(시치사토네 퓨전)
function c18452719.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,18452719+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c18452719.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetCountLimit(1)
	e2:SetCost(c18452719.cost2)
	e2:SetTarget(c18452719.tar2)
	e2:SetOperation(c18452719.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetTarget(c18452719.tar3)
	e3:SetOperation(c18452719.op3)
	c:RegisterEffect(e3)
end
function c18452719.ofil1(c)
	return c:IsCode(18452714) and c:IsAbleToHand()
end
function c18452719.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g=Duel.GetMatchingGroup(c18452719.ofil1,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(18452719,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c18452719.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c18452719.tfil21(c,e,tp,m1,m2,f,chkf)
	local mg=m1
	if c.december_fmaterial then
		mg:Merge(m2)
	end
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsSetCard(0x2d0)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg,nil,chkf)
end
function c18452719.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		local res=Duel.IsExistingMatchingCard(c18452719.tfil21,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,mg2,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c18452719.tfil1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,Group.CreateGroup(),mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,0)
end
function c18452719.ofil2(c,e)
	return not c:IsImmuneToEffect(e)
end
function c18452719.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c18452719.ofil2,nil,e)
	local mg2=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil):Filter(c18452719.ofil1,nil,e)
	local sg1=Duel.GetMatchingGroup(c18452719.tfil21,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,mg2,nil,chkf)
	local mg3=nil
	local sg2=nil
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c18452719.tfil21,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,Group.CreateGroup(),mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then
			sg:Merge(sg2)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat=nil
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if tc.december_fmaterial then
				mg1:Merge(mg2)
			end
			mat=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat)
			Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			mat=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat)
		end
		tc:CompleteProcedure()
	end
end
function c18452719.tfil3(c)
	return c:IsCode(18452714) and c:IsSummonable(true,nil)
end
function c18452719.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c18452719.tfil3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c18452719.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c18452719.tfil3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end