--노블레스 오블리주
local m=18453400
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrderProcedure(c,"<",cm.pfun1,aux.TRUE,aux.TRUE)
	local e1=MakeEff(c,"I","M")
	e1:SetCL(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"SC")
	e2:SetCode(EVENT_BE_MATERIAL)
	WriteEff(e2,2,"NO")
	c:RegisterEffect(e2)
end
function cm.pfun1(g)
	local st=cm.square_mana
	return aux.IsFitSquare(g,st)
end
cm.square_mana={ATTRIBUTE_WATER,ATTRIBUTE_FIRE}
cm.custom_type=CUSTOMTYPE_SQUARE
cm.CardType_Order=true
function cm.tfil1(c,tp)
	return c:IsSetCard(0x2d8) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (Duel.GetLocCount(tp,"S")>0 or c:IsType(TYPE_FIELD))
		and c:IsSSetable()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil,tp)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil,tp)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO or r==REASON_SQUARE
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=MakeEff(rc,"F","M")
	e1:SetCode(EFFECT_REMAIN_FIELD)
	e1:SetTR(0,"S")
	e1:SetD(m,0)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e1:SetTarget(cm.otar21)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=MakeEff(c,"S")
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		rc:RegisterEffect(e2,true)
	end
end
function cm.otar21(e,c)
	return c:IsType(TYPE_SPELL)
end