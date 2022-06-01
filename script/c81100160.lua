--QA 슈터
--카드군 번호: 0xcad
--refined 20.02.16.
local m=81100160
local cm=_G["c"..m]
function cm.initial_effect(c)

	aux.EnablePendulumAttribute(c)

	--소환제약
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.lim)
	c:RegisterEffect(e2)
	
	--펜듈럼효과
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8110160,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	
	--서치
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,m+1)
	e4:SetCondition(cm.cn4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e5)
end

--limit
function cm.lim(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0xcad) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

--펜듈럼효과
function cm.pfil(c,pc)
	return c:IsSetCard(0xcad) and c:IsType(TYPE_PENDULUM) and c:IsAbleToGrave() 
	and ( c:GetLeftScale()~=pc:GetLeftScale() and c:GetRightScale()~=pc:GetRightScale() )
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.pfil,tp,LOCATION_DECK,0,1,nil,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.pfil,tp,LOCATION_DECK,0,1,1,nil,c):GetFirst()
	if g and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(g:GetLeftScale())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		e2:SetValue(g:GetRightScale())
		c:RegisterEffect(e2)
	end
end

--회수
function cm.cn4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(0x0c) and c:IsControler(tp)
end
function cm.tfil0(c)
	return c:IsAbleToHand() and c:IsFaceup() and c:IsSetCard(0xcad) and c:IsType(TYPE_PENDULUM)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x40,0,1,nil) 
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x40)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tfil0,tp,0x40,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
	if sg then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
