--프린세스퀘어
local m=18453227
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetD(m,0)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_DICE)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"I","G")
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_DRAW)
	e6:SetCondition(aux.exccon)
	WriteEff(e6,6,"TO")
	c:RegisterEffect(e6)
end
cm.square_mana={ATTRIBUTE_FIRE,ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT,ATTRIBUTE_DIVINE,ATTRIBUTE_WIND,ATTRIBUTE_WATER,ATTRIBUTE_DARK}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.con1(e,c,minc)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocCount(tp,"M")>0
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=MakeEff(c,"S","M")
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetValue(800)
	c:RegisterEffect(e1)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"S")>0
	end
	Duel.SOI(0,CATEGORY_DICE,nil,0,tp,1)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if Duel.GetLocCount(tp,"S")<1 then
		return
	end
	local token
	if dc==1 then
		token=Duel.CreateToken(tp,93016201)
	elseif dc==2 then
		token=Duel.CreateToken(tp,51452091)
	elseif dc==3 then
		token=Duel.CreateToken(tp,33950246)
	elseif dc==4 then
		token=Duel.CreateToken(tp,30459350)
	elseif dc==5 then
		token=Duel.CreateToken(tp,26586849)
	elseif dc==6 then
		token=Duel.CreateToken(tp,61740673)
	end
	if token then
		if dc==2 then
			Duel.MoveToField(token,tp,tp,LSTN("S"),POS_FACEUP,true)
		else
			Duel.SSet(tp,token)
			if e:GetCode()==EVENT_SPSUMMON_SUCCESS then
				local e1=MakeEff(c,"S")
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				token:RegisterEffect(e1)
			end
		end
	end
end
function cm.tfil6(c)
	return (c:IsLoc("G") or c:IsFaceup()) and c:GetType()&TYPE_TRAP+TYPE_CONTINUOUS==TYPE_TRAP+TYPE_CONTINUOUS
end
function cm.tar6(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsLoc("SG") and chkc:IsControler(tp) and cm.tfil6(chkc)
	end
	if chk==0 then
		return c:IsAbleToHand() and Duel.IETarget(cm.tfil6,tp,"SG",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	Duel.STarget(tp,cm.tfil6,tp,"SG",0,1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,c,1,0,0)
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsAbleToDeck() and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end