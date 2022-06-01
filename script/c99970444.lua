--RH(레드 후드): 망월
local m=99970444
local cm=_G["c"..m]
function cm.initial_effect(c)

	--모듈 소환
	RevLim(c)
	aux.AddModuleProcedure(c,aux.FilterBoolFunction(Card.IsModuleSetCard,0xd34),aux.FilterBoolFunction(Card.IsModuleSetCard,0xd34),1,99,nil)

	--자괴 + 데미지
	local e1=MakeEff(c,"FTf","M")
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	
	--도발
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(cm.atktg)
	c:RegisterEffect(e2)
	
	--특수 소환 + 데미지
	local e3=MakeEff(c,"FTo","G")
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	WriteEff(e3,3,"NTO")
	e3:SetCountLimit(1,m)
	c:RegisterEffect(e3)
	
	--특수 소환 체크
	if not cm.global_check then
	cm.global_check=true
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
	ge1:SetLabel(m)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	ge1:SetOperation(aux.sumreg)
	Duel.RegisterEffect(ge1,0)
	end
	
end

--자괴 + 데미지
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)~=0 end
	e:GetHandler():ResetFlagEffect(m)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1500)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Damage(p,d,REASON_EFFECT)
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end

--도발
function cm.atktg(e,c)
	return c:IsFaceup() and c:IsSetCard(0xd34) and c~=e:GetHandler()
end

--특수 소환
function cm.cfilter(c)
	return c:IsSetCard(0xd34) and c:IsFaceup()
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
		Duel.Damage(1-tp,ev,REASON_EFFECT)
	end
end
