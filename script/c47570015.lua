--블렌디아 퓨전

local m=47570015
local cm=_G["c"..m]

function cm.initial_effect(c)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

	--ToDeck
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TODECK)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetCountLimit(1,m+1)
	e0:SetCondition(cm.tdcon)
	e0:SetTarget(cm.tdtg)
	e0:SetOperation(cm.tdop)
	c:RegisterEffect(e0)

end


function cm.mttg(e,c)
	local tc=c:GetEquipTarget()
	return tc and tc:IsSetCard(0xb2d)
end
function cm.mtval(e,c)
	if not c then return false end
	return c:IsSetCard(0xb2d)
end
function cm.filter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.filter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsType,nil,1,TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local me=Effect.CreateEffect(e:GetHandler())
		me:SetType(EFFECT_TYPE_FIELD)
		me:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
		me:SetTargetRange(LOCATION_SZONE,0)
		me:SetTarget(cm.mttg)
		me:SetValue(cm.mtval)
		Duel.RegisterEffect(me,tp)
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		Auxiliary.FCheckAdditional=cm.fcheck
		local res=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		Auxiliary.FCheckAdditional=nil
		me:Reset()
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end


function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local me=Effect.CreateEffect(e:GetHandler())
	me:SetType(EFFECT_TYPE_FIELD)
	me:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	me:SetTargetRange(LOCATION_SZONE,0)
	me:SetTarget(cm.mttg)
	me:SetValue(cm.mtval)
	Duel.RegisterEffect(me,tp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter2,nil,e)
	Auxiliary.FCheckAdditional=cm.fcheck
	local sg1=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	Auxiliary.FCheckAdditional=nil
	me:Reset()
end

function cm.exfilter(c,tp)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:GetSummonPlayer()==tp and c:GetSummonType()==SUMMON_TYPE_MODULE and c:IsFaceup()
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.exfilter,1,nil,tp)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,tp,2,REASON_EFFECT)
	end
end