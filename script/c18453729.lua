--프로미스테이
local m=18453729
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,cm.pfil1,cm.pfil2)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LSTN("O"),0,Duel.SendtoGrave,REASON_COST+REASON_MATERIAL)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"SC")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	WriteEff(e2,2,"NO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S","M")
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(cm.val3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","M")
	e4:SetCode(EVENT_CHAINING)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e4:SetCL(1)
	WriteEff(e4,4,"NTO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"STo")
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e5,5,"TO")
	c:RegisterEffect(e5)
end
function cm.pfil1(c,fc,sub,mg,sg)
	if c:IsFusionCode(18453082) or (sub and c:CheckFusionSubstitute(fc)) then
		if not sg or sg:FilterCount(aux.TRUE,c)<1 then
			return true
		end
		local g=sg:Clone()
		g:AddCard(c)
		local st=fc.square_mana
		return aux.IsFitSquare(g,st)
	end
	return false
end
function cm.pfil2(c,fc,sub,mg,sg)
	if c:IsFusionCode(18453590) or (sub and c:CheckFusionSubstitute(fc)) then
		if not sg or sg:FilterCount(aux.TRUE,c)<1 then
			return true
		end
		local g=sg:Clone()
		g:AddCard(c)
		local st=fc.square_mana
		return aux.IsFitSquare(g,st)
	end
	return false
end
cm.square_mana={ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT,ATTRIBUTE_LIGHT,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.val1(e,se,sp,st)
	local c=e:GetHandler()
	return st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION or not c:IsLocation(LOCATION_EXTRA)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonLocation()==LSTN("E")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_PROMISED_END)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTR(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCL(1)
	e2:SetLabel(Duel.GetTurnCount())
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	e2:SetCondition(cm.ocon22)
	e2:SetOperation(cm.oop22)
	Duel.RegisterEffect(e2,tp)
	local e3=MakeEff(c,"F")
	e3:SetCode(EFFECT_PUBLIC)
	e3:SetTR(0,"H")
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp)
	local g=Duel.GMGroup(Card.IsFacedown,tp,0,0xff,nil)
	Duel.PromisedEnd(tp,g)
	local e4=MakeEff(c,"FC")
	e4:SetCode(EVENT_MOVE)
	e4:SetReset(RESET_PHASE+PHASE_END,2)
	e4:SetOperation(cm.oop24)
	Duel.RegisterEffect(e4,tp)
end
function cm.ocon22(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()~=Duel.GetTurnCount() and Duel.GetTurnPlayer()~=tp
end
function cm.oop22(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()~=Duel.GetTurnCount() and Duel.GetTurnPlayer()~=tp then
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_EXTRA_TURN)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTR(0,1)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		e:Reset()
	end
end
function cm.oofil24(c,tp)
	return c:IsControler(1-tp) and c:IsFacedown()
end
function cm.oop24(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.oofil24,nil,tp)
	Duel.PromisedEnd(tp,g)	
end
function cm.val3(e,te)
	return te:IsHasType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_QUICK_F)
		or (te:IsHasType(EFFECT_TYPE_ACTIVATE) and te:IsActiveType(TYPE_QUICKPLAY+TYPE_TRAP))
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and loc&LSTN("MG")~=0 and re:IsActiveType(TYPE_MONSTER)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then
		return rc:IsRelateToEffect(re) and Duel.GetLocCount(tp,"M")>0 and rc:IsControler(1-tp)
			and ((rc:IsLoc("G") or rc:IsCanBeSpecialSummoned(e,0,tp,false,false))
				or (rc:IsLoc("M") or rc:IsControlerCanBeChanged()))
	end
	if rc:IsLoc("G") then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE+CATEGORY_RECOVER)
		Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,eg,1,0,0)
	else
		e:SetCategory(CATEGORY_CONTROL+CATEGORY_DAMAGE+CATEGORY_RECOVER)
		Duel.SOI(0,CATEGORY_CONTROL,eg,1,0,0)
	end
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsControler(1-tp) then
		if rc:IsLoc("G") then
			Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEUP)
		elseif rc:IsLoc("M") then
			Duel.GetControl(rc,tp)
		end
		if rc:IsFaceup() and rc:IsControler(tp) and rc:IsLoc("M") then
			Duel.Damage(1-tp,math.ceil(rc:GetAttack()/2),REASON_EFFECT)
			Duel.Recover(tp,math.ceil(rc:GetDefense()/2),REASON_EFFECT)
		end
	end
end
function cm.tfil5(c,e,tp)
	return (c:IsCode(18453082) or c:IsCode(18453590)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil5(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil5,tp,"G",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.tfil5,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end