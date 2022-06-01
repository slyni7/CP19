--Arom@$er@phy Angellic@
local m=18453194
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","D")
	e2:SetCode(EFFECT_SPSUMMON_PROC_G)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","HM")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"I","G")
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e4,4,"NTO")
	c:RegisterEffect(e4)
end
cm.square_mana={ATTRIBUTE_LIGHT}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.nfil2(c)
	return c:IsSetCard("Æ÷¼Ç") and c:GetType()==TYPE_SPELL and c:IsAbleToDeckAsCost()
end
function cm.con2(e,c,og)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return c:IsAbleToDeck() and Duel.IEMCard(cm.nfil2,tp,"G",0,1,nil) and Duel.GetFlagEffect(tp,m)==0
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SMCard(tp,cm.nfil2,tp,"G",0,0,1,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,2,REASON_COST)
		Duel.SendtoGrave(c,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
end
function cm.tfil3(c,e,tp)
	return c:IsSetCard(0x2e6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil3(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetMZoneCount(tp,c,tp)>0 and Duel.IETarget(cm.tfil3,tp,"G",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.tfil3,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"G")
	local tc=g:GetFirst()
	local rec=(c:GetLevel()+c:GetRank()+c:GetLink())*100
	Duel.SOI(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local rec=(tc:GetLevel()+tc:GetRank()+tc:GetLink())*100
		Duel.Recover(tp,rec,REASON_EFFECT)
	end
end
function cm.nfil4(c)
	return c:IsSetCard(0x2e6) and c:IsFaceup()
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(1-tp)>0 and math.floor(Duel.GetLP(tp)/Duel.GetLP(1-tp))>=2
		and Duel.IEMCard(cm.nfil4,tp,"M",0,1,nil)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECKSHF)
		c:RegisterEffect(e1,true)
	end
end