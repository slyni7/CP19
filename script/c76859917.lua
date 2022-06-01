--클래식 메모리얼 - 사텐
local m=76859917
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"I","H")
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tfil1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function cm.tfun1(g)
	return g:IsExists(Card.IsSetCard,1,nil,0x2c0)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	local g=Duel.GMGroup(cm.tfil1,tp,"R",0,nil,e)
	if chk==0 then
		return cm.tfun1(g)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,cm.tfun1,false,1,4)
	Duel.SetTargetCard(sg)
	Duel.SOI(0,CATEGORY_TODECK,sg,#sg,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if #g>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
	local e1=MakeEff(c,"F")
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_REMOVE)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.oop12)
	Duel.RegisterEffect(e2,tp)
end
function cm.oop12(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	if #g==0 then
		return
	end
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
		Duel.Hint(HINT_CARD,0,m)
		local te=e:GetLabelObject()
		te:Reset()
		e:Reset()
	end
end
function cm.tfil2(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	local g=Duel.GMGroup(cm.tfil2,tp,"G",0,nil,e)
	if chk==0 then
		return cm.tfun1(g)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,cm.tfun1,false,1,4)
	Duel.SetTargetCard(sg)
	Duel.SOI(0,CATEGORY_TODECK,sg,#sg,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if #g>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
	local e1=MakeEff(c,"F")
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetTR(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetLabelObject(e1)
	e2:SetOperation(cm.oop12)
	Duel.RegisterEffect(e2,tp)
end