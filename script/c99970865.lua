--[ D:011 ]
local s,id=GetID()
function s.initial_effect(c)

	local e0=MakeEff(c,"Qo","H")
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCL(1,id)
	WriteEff(e0,0,"NTO")
	c:RegisterEffect(e0)
	
	local e1=MakeEff(c,"STo")
	e1:SetD(id,0)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_DAMAGE_STEP|EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	local e2=MakeEff(c,"STo")
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)

	if not s.global_check then
		s.global_check=true
		s[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		ge1:SetOperation(s.gop)
		Duel.RegisterEffect(ge1,0)
	end
	
end

function s.gop(e,tp,eg,ep,ev,re,r,rp)
	s[0]=s[0]+#eg
end

function s.con0(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0xcd6e),tp,LOCATION_MZONE,0,1,nil)
end
function s.tar0(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
			Duel.BreakEffect()
			YuL.FlipSummon(e,tp)
		end
	end
end	

function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=s[0]//3
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated()
		and re:GetHandler():IsSetCard(0xcd6e)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_GRAVE)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
