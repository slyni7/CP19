--뱀피릭 메소드
local m=18453398
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddModuleProcedure(c,nil,nil,1,99,cm.pfun1)
	local e1=MakeEff(c,"FTo","M")
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetCL(1)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"SC")
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)
	--Damage
	local e3=MakeEff(c,"SC")
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetLabelObject(e2)
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)
end
cm.square_mana={ATTRIBUTE_FIRE,ATTRIBUTE_WIND,ATTRIBUTE_WATER}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.pfun1(g)
	local st=cm.square_mana
	return aux.IsFitSquare(g,st)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,0,LSTN("HO"))>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	e:SetLabel(Duel.SelectOption(tp,70,71,72))
end
function cm.ofil1(c,typ)
	return c:IsType(typ) and (c:IsControlerCanBeChanged() or c:IsLoc("H"))
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local typ=1<<e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g=Duel.SMCard(1-tp,cm.ofil1,tp,0,"HO",1,1,nil,typ)
	local tc=g:GetFirst()
	if tc then
		if tc:IsOnField() then
			Duel.GetControl(tc,tp,0,0)
		else
			Duel.SendtoHand(tc,tp,REASON_RULE)
		end
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
	if rp==1-tp and e:GetLabelObject():GetLabel()==0 and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LSTN("O")) and c:IsPreviousPosition(POS_FACEUP) then
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
function cm.oofil31(c)
	return c:IsCode(m) and (c:IsFaceup() or not c:IsLoc("R"))
end
function cm.oop31(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 or
		e:GetLabel()==Duel.GetTurnCount() or
		Duel.GetCurrentPhase()<=PHASE_MAIN1 or
		Duel.GetCurrentPhase()>=PHASE_MAIN2 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SMCard(tp,cm.oofil31,tp,"EGR",0,1,1,nil)
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