--마음의 유령유희 오메가
local m=18452995
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddFusionProcFunRep(c,cm.pfil1,2,false)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LSTN("M"),0,Duel.Release,REASON_COST+REASON_MATERIAL)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,m)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","M")
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCondition(cm.con2)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTo","M")
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetCountLimit(1,m)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
end
function cm.pfil1(c,fc,sub,mg,sg)
	if not c:IsSetCard(0x2de) then
		return false
	end
	if not sg or sg:FilterCount(aux.TRUE,c)==0 then
		return true
	end
	local g=sg:Clone()
	g:AddCard(c)
	local st=fc.square_mana
	return aux.IsFitSquare(g,st)
end
cm.square_mana={ATTRIBUTE_FIRE,ATTRIBUTE_WIND,ATTRIBUTE_WATER}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.val1(e,se,sp,st)
	local c=e:GetHandler()
	return st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION or not c:IsLocation(LOCATION_EXTRA)
end
function cm.nfil1(c)
	return c:IsType(TYPE_SYNCHRO+TYPE_XYZ) and c:IsFaceup()
end
function cm.con2(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return c:GetSequence()>4 and Duel.IEMCard(cm.nfil1,tp,"M",0,1,nil)
end
function cm.nfil3(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and bit.band(c:GetPreviousTypeOnField(),TYPE_SYNCHRO+TYPE_XYZ)>0
		and (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil3,1,nil,tp,rp)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged()
	end
	if chk==0 then
		return Duel.IETarget(Card.IsControlerCanBeChanged,tp,0,"M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.STarget(tp,Card.IsControlerCanBeChanged,tp,0,"M",1,1,nil)
	Duel.SOI(0,CATEGORY_CONTROL,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end
