--컬러 리플렉터
local m=18453409
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrderProcedure(c,"<",cm.pfun1,aux.TRUE,aux.TRUE)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1,m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
end
function cm.pfun1(g)
	local st=cm.square_mana
	return aux.IsFitSquare(g,st)
end
cm.square_mana={ATTRIBUTE_WIND,ATTRIBUTE_DARK}
cm.custom_type=CUSTOMTYPE_SQUARE
cm.CardType_Order=true
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_ORDER)
end
function cm.tfil1(c)
	return c:IsSetCard("컬러큐브") and c:GetType()&TYPE_SPELL+TYPE_CONTINUOUS==TYPE_SPELL+TYPE_CONTINUOUS and c:IsAbleToHand()
end
function cm.tfun1(g)
	local fc=g:GetFirst()
	local nc=g:GetNext()
	if fc:IsCode(18452855) and nc:IsCode(18452860) then
		return true
	end
	if fc:IsCode(18452860) and nc:IsCode(18452855) then
		return true
	end
	if fc:IsCode(18452857) and nc:IsCode(18452859) then
		return true
	end
	if fc:IsCode(18452859) and nc:IsCode(18452857) then
		return true
	end
	if fc:IsCode(18452858) and nc:IsCode(18452861) then
		return true
	end
	if fc:IsCode(18452861) and nc:IsCode(18452858) then
		return true
	end
	return false
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(cm.tfil1,tp,"D",0,nil)
	if chk==0 then
		return g:CheckSubGroup(cm.tfun1,2,2)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,2,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(cm.tfil1,tp,"D",0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,cm.tfun1,false,2,2)
	if #sg==2 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end