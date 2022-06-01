--진염앵혼-야에 사쿠라
--카드군 번회: 0xcbc
function c81230010.initial_effect(c)

	c:EnableCounterPermit(0xcbc)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(c81230010.mat),1,1)
	
	--전투파괴 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
	--상대몬스터를 묘지로 보낸다
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81230010,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c81230010.cn2)
	e2:SetTarget(c81230010.tg2)
	e2:SetOperation(c81230010.op2)
	c:RegisterEffect(e2)
	
	--프리체인 견제
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81230010,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81230010)
	e3:SetCost(c81230010.co3)
	e3:SetTarget(c81230010.tg3)
	e3:SetOperation(c81230010.op3)
	c:RegisterEffect(e3)
end

--싱크로 소재
function c81230010.mat(c)
	return c:IsType(0x20) and c:IsSetCard(0xcbc)
end

--상대몬스터를 묘지로 보낸다
function c81230010.cn2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c81230010.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c81230010.op2(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.SendtoGrave(bc,REASON_EFFECT)
	end
end

--프리체인 견제
function c81230010.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsCanRemoveCounter(tp,1,0,0xcbc,2,REASON_COST)
	end
	Duel.RemoveCounter(tp,1,0,0xcbc,2,REASON_COST)
end
function c81230010.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsFaceup() and chkc:IsOnField()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c81230010.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,800,REASON_EFFECT)
	end
end


