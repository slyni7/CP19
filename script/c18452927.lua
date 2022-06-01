--벨로시티즌 이그나이터 자로
local m=18452927
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"I","G")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","H")
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_DESTROY)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
cm.square_mana={ATTRIBUTE_DARK,ATTRIBUTE_DARK,ATTRIBUTE_DARK}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function cm.tfil1(c)
	return c:IsSetCard(0x2dc) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.con2(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocCount(tp,"M")>0 and Duel.GetFieldGroupCount(tp,LSTN("M"),0)<1
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(m)<1 or (c:IsHasEffect(18452936) and c:GetFlagEffect(m-1000)<1)
	end
	c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
	c:RegisterFlagEffect(m-1000,RESET_CHAIN,0,1)
end
function cm.tfil31(c,e)
	return c:IsSetCard(0x2dc) and c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function cm.tfil32(c,g)
	local sum=c:GetLevel()+c:GetRank()+c:GetLink()
	return c:IsFaceup() and g:CheckSubGroup(cm.tfun3,1,#g,sum)
end
function cm.tfun3(g,sum)
	local gsum=g:GetSum(cm.tval3)
	return gsum>=sum
end
function cm.tval3(c)
	return c:GetLevel()+c:GetRank()+c:GetLink()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	local g=Duel.GMGroup(cm.tfil31,tp,"M",0,nil,e)
	if chk==0 then
		return Duel.IETarget(cm.tfil32,tp,0,"M",1,nil,g)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=Duel.STarget(tp,cm.tfil32,tp,0,"M",1,1,nil,g)
	local tc=tg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sum=tc:GetLevel()+tc:GetRank()+tc:GetLink()
	local dg=g:SelectSubGroup(tp,cm.tfun3,false,1,#g,sum)
	Duel.SetTargetCard(dg)
	tg:Merge(dg)
	Duel.SOI(0,CATEGORY_DESTROY,tg,#tg,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end