--피닉스퀘어
local m=18453401
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	aux.AddEquationProcedure(c,aux.ProcFitSquare(cm),8,2,0)
	c:SetUniqueOnField(1,0,m)
	local e1=MakeEff(c,"FTo","M")
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TODECK)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"SC")
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"SC")
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetLabelObject(e2)
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)
end
cm.square_mana={ATTRIBUTE_FIRE,ATTRIBUTE_FIRE,ATTRIBUTE_FIRE,ATTRIBUTE_FIRE,ATTRIBUTE_WIND,ATTRIBUTE_WIND,ATTRIBUTE_WIND,ATTRIBUTE_WIND}
cm.custom_type=CUSTOMTYPE_SQUARE+CUSTOMTYPE_EQUATION
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function cm.tfil1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and cm.tfil1(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil1,tp,"O","O",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.STarget(tp,cm.tfil1,tp,"O","O",1,1,nil)
	Duel.SOI(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabelObject():GetLabel()==0 and c:IsPreviousLocation(LSTN("O")) and c:IsPreviousPosition(POS_FACEUP) then
		local ct=0
		if Duel.GetCurrentPhase()>PHASE_MAIN1 and Duel.GetCurrentPhase()<PHASE_MAIN2 then
			ct=Duel.GetTurnCount()
		end
		local e1=MakeEff(c,"FC")
		e1:SetCode(EVENT_ADJUST)
		e1:SetLabel(ct)
		e1:SetOperation(cm.oop31)
		Duel.RegisterEffect(e1,tp)
		local e2=MakeEff(c,"FC")
		e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e2:SetCountLimit(1)
		e2:SetLabel(ct)
		e1:SetLabelObject(e2)
		e2:SetLabelObject(e1)
		e2:SetOperation(cm.oop32)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.oofil31(c,tp)
	return c:IsCode(m) and (c:IsFaceup() or not c:IsLoc("R")) and c:CheckUniqueOnField(tp)
end
function cm.oop31(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 or
		e:GetLabel()==Duel.GetTurnCount() or
		Duel.GetCurrentPhase()<=PHASE_MAIN1 or
		Duel.GetCurrentPhase()>=PHASE_MAIN2 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SMCard(tp,cm.oofil31,tp,"EGR",0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LSTN("M"),POS_FACEUP,true) then
		e:GetLabelObject():Reset()
		e:Reset()
	end
end
function cm.oop32(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==Duel.GetTurnCount() then
		return
	end
	e:GetLabelObject():Reset()
	e:Reset()
end