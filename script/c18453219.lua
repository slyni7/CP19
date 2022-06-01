--Trick$t@r Lycori$
local m=18453219
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetD(m,0)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","H")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetD(m,1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC","M")
	e3:SetCode(EVENT_TO_HAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	WriteEff(e3,3,"NO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FC","M")
	e4:SetCode(EVENT_TO_HAND)
	WriteEff(e4,4,"NO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"FC","M")
	e5:SetCode(EVENT_CHAIN_SOLVED)
	WriteEff(e5,5,"NO")
	c:RegisterEffect(e5)
	if not cm.global_check then
		cm.global_check=true
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(cm.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
cm.square_mana={ATTRIBUTE_FIRE,ATTRIBUTE_FIRE,ATTRIBUTE_FIRE}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	cm.chain_solving=true
end
function cm.gop2(e,tp,eg,ep,ev,re,r,rp)
	cm.chain_solving=false
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(m)<1
	end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsSummonable(true,nil)
	end
	Duel.SOI(0,CATEGORY_SUMMON,c,1,0,0)
	Duel.SetChainLimit(cm.clim1)
end
function cm.clim1(e,ep,tp)
	local c=e:GetHandler()
	return c:IsType(TYPE_TUNER) or tp==ep
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSummonable(true,nil) then
		Duel.Summon(tp,c,true,nil)
	end
end
function cm.tfil21(c)
	return c:IsSetCard(0x2e9) and c:IsFaceup() and c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function cm.tfil22(c)
	return c:IsSetCard(0x2e9) and c:IsFaceup() and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	local chain=Duel.GetCurrentChain()
	for i=1,chain do
		local te,tg=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
		if e==te and tg then
			g:Merge(tg)
		end
	end
	local gg=Duel.GMGroup(cm.tfil21,tp,"S",0,nil)
	local tc=gg:GetFirst()
	while tc do
		tc:CancelToGrave()
		tc=gg:GetNext()
	end
	if chkc then
		return chkc:IsControler(tp) and chkc:IsOnField() and cm.tfil22(chkc) and not g:IsContains(chkc)
	end
	if chk==0 then
		local res=c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0
			and Duel.IETarget(cm.tfil22,tp,"O",0,1,g)
		local tc=gg:GetFirst()
		while tc do
			tc:CancelToGrave(false)
			tc=gg:GetNext()
		end
		return res
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=Duel.STarget(tp,cm.tfil22,tp,"O",0,1,1,g)
	local tc=gg:GetFirst()
	while tc do
		tc:CancelToGrave(false)
		tc=gg:GetNext()
	end
	Duel.SOI(0,CATEGORY_TOHAND,sg,1,0,0)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetChainLimit(cm.clim1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	if tc:IsRelateToEffect(e) then
		if not tc:IsImmuneToEffect(e) and cm.tfil21(tc) then
			tc:CancelToGrave()
		end
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp) and not cm.chain_solving
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local ct=eg:FilterCount(Card.IsControler,nil,1-tp)
	Duel.Damage(1-tp,ct*200,REASON_EFFECT)
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp) and cm.chain_solving
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=eg:FilterCount(Card.IsControler,nil,1-tp)
	c:RegisterFlagEffect(m+1,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,ct)
end
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m+1)>0
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,m)
	local labels={c:GetFlagEffectLabel(m+1)}
	local ct=0
	for i=1,#labels do
		ct=ct+labels[i]
	end
	c:ResetFlagEffect(m+1)
	Duel.Damage(1-tp,ct*200,REASON_EFFECT)
end