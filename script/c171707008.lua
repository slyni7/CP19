--버서키드 스플래터
local s,id=GetID()
function s.initial_effect(c)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.con0)
	c:RegisterEffect(e0)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)

	local e2=MakeEff(c,"Qo","G")
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCL(1,id)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
end

function s.con0(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end

function s.desfilter(c,tp)
	return (c:IsFaceup() and c:IsSetCard(0x706) and c:IsControler(tp)) or c:IsControler(1-tp)
end
function s.rescon(sg,e,tp,mg)
    return sg:FilterCount(Card.IsControler,nil,tp)==sg:FilterCount(Card.IsControler,nil,1-tp)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_ONFIELD,nil,tp)
	if chk==0 then return aux.SelectUnselectGroup(rg,e,tp,2,30,s.rescon,0) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rg,2,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_ONFIELD,nil,tp)
	local g=aux.SelectUnselectGroup(rg,e,tp,2,30,s.rescon,1,tp,HINTMSG_DESTROY)
	if #g>=2 then
		Duel.HintSelection(g,true)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

function s.tar2fil(c)
	return c:IsFaceup() and c:IsSetCard(0x706)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.tar2fil(chkc) and chkc:IsControler(tp) end
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingTarget(s.tar2fil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.tar2fil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,c)
		if tc and tc:IsRelateToEffect(e) then
		    Duel.BreakEffect()
		    Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end

