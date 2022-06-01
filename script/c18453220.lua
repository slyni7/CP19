--Trick$t@r Lilybell
local m=18453220
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SUMMON)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCL(1)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"STo")
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_TOHAND)
	WriteEff(e4,4,"NTO")
	c:RegisterEffect(e4)
end
cm.square_mana={ATTRIBUTE_WATER,ATTRIBUTE_WATER}
cm.custom_type=CUSTOMTYPE_SQUARE
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
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g,b=c:GetAttackableTarget()
		return c:IsAttackable() and b
	end
	Duel.SetChainLimit(cm.clim1)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g,b=c:GetAttackableTarget()
	if c:IsRelateToEffect(e) and c:IsAttackable() and b then
		Duel.CalculateDamage(c,nil)
	end
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function cm.tfil4(c)
	return c:IsSetCard(0x2e9) and c:IsAbleToHand()
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil4(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil4,tp,"G",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.STarget(tp,cm.tfil4,tp,"G",0,1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetChainLimit(cm.clim1)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end