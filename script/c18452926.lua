--벨로시티즌 스피더 파이로
local m=18452926
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"I","G")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","H")
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	WriteEff(e3,3,"NCTO")
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
function cm.tfil1(c,e,tp)
	return c:IsSetCard(0x2dc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IETarget(cm.tfil1,tp,"G",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.tfil1,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.nfil2(c)
	return c:IsSetCard(0x2dc) and c:IsFaceup() and not c:IsCode(m)
end
function cm.con2(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(cm.nfil2,tp,"M",0,1,nil)
end
function cm.nfil3(c)
	return c:IsSetCard(0x2dc) and c:IsFaceup()
end
function cm.nval3(c)
	return c:GetLevel()+c:GetRank()+c:GetLink()
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	if #eg~=1 or ep==tp or Duel.GetCurrentChain()>0 then
		return false
	end
	local g=Duel.GMGroup(cm.nfil3,tp,"M",0,nil)
	local tc=eg:GetFirst()
	local sum=g:GetSum(cm.nval3)
	local tsum=tc:GetLevel()+tc:GetRank()+tc:GetLink()
	return tsum<=sum
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHandAsCost()
	end
	Duel.SendtoHand(c,nil,REASON_COST)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_DISABLE_SUMMON,eg,1,0,0)
	Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end