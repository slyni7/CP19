--Arom@ J@r
local m=18453193
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"F","H")
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetD(m,0)
	e1:SetCL(1,m)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","D")
	e2:SetCode(EFFECT_SPSUMMON_PROC_G)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S","M")
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCondition(cm.con3)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"FTf","M")
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetCountLimit(1)
	WriteEff(e5,5,"NTO")
	c:RegisterEffect(e5)
end
cm.square_mana={ATTRIBUTE_WIND}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.nfil1(c,e,tp)
	return c:IsSetCard(0x2e6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
end
function cm.con1(e,c,og)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LSTN("M"),0)==0 and Duel.GetLocCount(tp,"M")>1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IEMCard(cm.nfil1,tp,"D",0,1,nil,e,tp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.nfil1,tp,"D",0,0,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		sg:AddCard(c)
		sg:Merge(tc)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
		local e2=e1:Clone()
		tc:RegisterEffect(e2,true)
	end
end
function cm.nfil2(c)
	return c:IsSetCard("Æ÷¼Ç") and c:GetType()==TYPE_SPELL and c:IsAbleToDeckAsCost()
end
function cm.con2(e,c,og)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return c:IsAbleToHand() and Duel.IEMCard(cm.nfil2,tp,"H",0,1,nil) and Duel.GetFlagEffect(tp,m)==0
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SMCard(tp,cm.nfil2,tp,"H",0,0,1,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,2,REASON_COST)
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.con3(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,500,REASON_EFFECT)
end