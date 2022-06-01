--중장 토끼-은랑의 여명
--카드군 번호: 0xcbd
function c81240040.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcbd),1,1,c81240040.mat)
	
	--프리체인
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81240040,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c81240040.cn1)
	e1:SetTarget(c81240040.tg1)
	e1:SetOperation(c81240040.op1)
	c:RegisterEffect(e1)
	
	--드로우
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81240040,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81240040)
	e2:SetCondition(c81240040.cn2)
	e2:SetTarget(c81240040.tg2)
	e2:SetOperation(c81240040.op2)
	c:RegisterEffect(e2)
end

--링크 소재
function c81240040.mat(g,lc)
	return not g:IsExists(Card.IsType,1,nil,TYPE_LINK)
end

--프리체인
function c81240040.cn1(e)
	return e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0xcbd)
end
function c81240040.filter0(c)
	return c:IsFaceup() and c:IsSetCard(0xcbd)
end
function c81240040.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local zone=0x0c+0x10
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81240040.filter0,tp,LOCATION_ONFIELD,0,1,c)
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,zone,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c81240040.filter0,tp,LOCATION_ONFIELD,0,1,1,c)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,zone,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
end
function c81240040.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lc=tg:GetFirst()
	if lc==tc then lc=tg:GetNext() end
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0
	and lc:IsRelateToEffect(e) and lc:IsControler(1-tp) then
		Duel.SendtoHand(lc,nil,REASON_EFFECT)
	end
end

--드로우
function c81240040.filter1(c,tp)
	return c:IsSetCard(0xcbd) and c:IsType(TYPE_UNION) and c:GetPreviousControler()==tp
end
function c81240040.cn2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81240040.filter1,1,nil,tp)
end
function c81240040.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c81240040.op2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end


