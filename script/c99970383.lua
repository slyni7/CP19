--Pluviatt
local m=99970383
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	YuL.Equip(c)
	
	--공격 불가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e1)

	--서치
	local e2=MakeEff(c,"FTo","S")
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)

	--공수 반전
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(cm.atkcon)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)

end

--서치
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	return tc~=nil and Duel.GetAttackTarget()==tc
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=10 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.thfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,10)
	local g=Duel.GetDecktopGroup(p,10)
	if g:GetCount()>0 and g:IsExists(cm.thfilter,1,nil) and Duel.SelectYesNo(p,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(p,cm.thfilter,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-p,sg)
		Duel.ShuffleHand(p)
	end
	Duel.ShuffleDeck(p)
end

--공수 반전
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_MODULE
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SWAP_BASE_AD)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	rc:RegisterEffect(e1,true)
end
