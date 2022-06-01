--[ hololive 1st Gen ]
local m=99970631
local cm=_G["c"..m]
function cm.initial_effect(c)

	--엑시즈 소환
	RevLim(c)
	aux.AddXyzProcedure(c,aux.FBF(Card.IsSetCard,0xe19),4,2)
	
	--데미지 + 회복
	local e1=MakeEff(c,"Qo","M")
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1)
	e1:SetCost(spinel.rmovcost(1))
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--내성
	local e0=MakeEff(c,"S","M")
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetCondition(cm.immcon)
	e0:SetValue(cm.efilter)
	c:RegisterEffect(e0)
	
	--자가 소생 + 회복
	local e2=MakeEff(c,"STo")
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e2:SetProperty(spinel.delay)
	e2:SetCode(EVENT_TO_GRAVE)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
	--회복 체크
	aux.GlobalCheck(cm,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_RECOVER)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
	
end

--회복 체크
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		Duel.RegisterFlagEffect(ep,m,RESET_PHASE+PHASE_END,0,1)
	end
end

--데미지 + 회복
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
	Duel.Recover(tp,1000,REASON_EFFECT)
end

--효과 내성
function cm.immcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)~=0
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--자가 소생 + 회복
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetOverlayCount()>0
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	end
end
