--헤븐 다크사이트
local m=18452836
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","H")
	e2:SetCode(EFFECT_SPELL_ACT_IN_NTPHAND)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_SPEED)
	e3:SetLabelObject(e1)
	e3:SetValue(cm.val3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"F","F")
	e4:SetCode(EFFECT_SWAP_AD)
	e4:SetTargetRange(LSTN("M"),0)
	e4:SetTarget(cm.tar4)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"Qo","F")
	e5:SetCode(EVENT_CHAINING)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	WriteEff(e5,5,"NTO")
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"FC","F")
	e6:SetCode(EVENT_CHAINING)
	WriteEff(e6,6,"NO")
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"STf")
	e7:SetCode(EVENT_LEAVE_FIELD)
	e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e7:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_POSITION)
	WriteEff(e7,7,"TO")
	c:RegisterEffect(e7)
	local e8=MakeEff(c,"F","F")
	e8:SetCode(EFFECT_SET_ATTACK)
	e8:SetTargetRange(LSTN("M"),0)
	e8:SetTarget(cm.tar8)
	e8:SetValue(1800)
	e8:SetLabelObject(e4)
	c:RegisterEffect(e8)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=false
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.ofil1(c)
	return c:IsSetCard(0x2d9) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.ofil1,tp,"D",0,0,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.con2(e)
	local tp=e:GetHandlerPlayer()
	return cm[0] and Duel.GetTurnPlayer()~=tp
end
function cm.val3(e,te)
	if te==e:GetLabelObject() then
		return 2
	end
	return 0
end
function cm.tar4(e,c)
	return c:GetBaseAttack()==0 and c:IsType(TYPE_TUNER)
end
function cm.nfil5(c)
	return c:IsFaceup() and c:IsSetCard(0x2d9)
end
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not Duel.IEMCard(cm.nfil5,tp,"O",0,1,c)
end
function cm.tfil51(c,tp)
	return c:IsAttack(0) and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
		and (c:IsSetCard(0x2d9) or Duel.IEMCard(Card.IsSetCard,tp,"H",0,1,nil,0x2d9))
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(m)<1 and Duel.IEMCard(cm.tfil51,tp,"D",0,1,nil,tp)
	end
	c:RegisterFlagEffect(m,RESET_PHASE+PHASE_END+RESET_EVENT+0x1ec0000,0,1)
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
	Duel.SOI(0,CATEGORY_DISCARD,nil,0,tp,1)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SMCard(tp,cm.tfil51,tp,"D",0,1,1,nil,tp)
		if #g1>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local g2=Duel.SMCard(tp,Card.IsSetCard,tp,"H",0,1,1,nil,0x2d9)
			if #g2>0 then
				Duel.SendtoGrave(g2,REASON_EFFECT)
			end
		end
	end
end
function cm.con6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IEMCard(cm.nfil5,tp,"O",0,1,c) and c:GetFlagEffect(m)<1 and Duel.IEMCard(cm.tfil51,tp,"D",0,1,nil,tp)
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(m,00)) then
		c:RegisterFlagEffect(m,RESET_PHASE+PHASE_END+RESET_EVENT+0x1ec0000,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SMCard(tp,cm.tfil51,tp,"D",0,1,1,nil,tp)
		if #g1>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local g2=Duel.SMCard(tp,Card.IsSetCard,tp,"H",0,1,1,nil,0x2d9)
			if #g2>0 then
				Duel.SendtoGrave(g2,REASON_EFFECT)
			end
		end
	end
end
function cm.tfil71(c)
	return c:IsAttack(0) and c:IsType(TYPE_MONSTER)
end
function cm.tfil72(c)
	return c:IsFaceup() and c:IsAttackPos() and c:IsAttack(0) and c:IsType(TYPE_TUNER) and c:IsCanChangePosition()
end
function cm.tar7(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil71(chkc)
	end
	if chk==0 then
		return true
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.STarget(tp,cm.tfil71,tp,"G",0,1,1,nil)
	if #g>0 then
		Duel.SOI(0,CATEGORY_TOHAND,nil,2,tp,"DG")
	end
	local sg=Duel.GMGroup(cm.tfil72,tp,"M",0,nil)
	Duel.SOI(0,CATEGORY_POSITION,sg,#sg,0,0)
end
function cm.ofil71(c)
	return c:IsAttack(0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.ofun7(g)
	local tc=g:GetFirst()
	local nc=g:GetNext()
	return ((tc:IsLoc("G") and nc:IsLoc("D")) or (tc:IsLoc("D") and nc:IsLoc("G")))
		and ((tc:IsType(TYPE_TUNER) and nc:IsRace(RACE_FAIRY)) or (tc:IsRace(RACE_FAIRY) and nc:IsType(TYPE_TUNER)))
end
function cm.op7(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(cm.tfil72,tp,"M",0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,01)) then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsAbleToHand() then
		local tg=Duel.GMGroup(cm.ofil71,tp,"D",0,nil)
		tg:AddCard(tc)
		Duel.SetSelectedCard(tc)
		if tg:CheckSubGroup(cm.ofun7,2,2) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=tg:SelectSubGroup(tp,cm.ofun7,false,2,2)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function cm.tar8(e,c)
	local te=e:GetLabelObject()
	local eset={c:IsHasEffect(EFFECT_SWAP_AD)}
	local res=false
	for _,se in pairs(eset) do
		if se==te then
			res=true
		end
	end
	return res and c:GetBaseAttack()==0 and c:IsType(TYPE_TUNER) and c:IsHasEffect(18452854)
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	if r&REASON_COST>0 then
		cm[0]=true
	end
end
function cm.gop2(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=false
end