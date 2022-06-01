--[ Pneumamancy ]
local m=99970380
local cm=_G["c"..m]
function cm.initial_effect(c)

	--강령술
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.pneu_tg)
	e1:SetOperation(cm.pneu_op)
	c:RegisterEffect(e1)
	
	--대상 내성 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	
	--샐비지
	local e3=MakeEff(c,"STo")
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(spinel.delay)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCL(1,m)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_TO_GRAVE)
	WriteEff(e4,4,"N")
	c:RegisterEffect(e4)
	
end

--강령술
function cm.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe12)
end
function cm.eqfilter2(c)
	return c:IsSetCard(0xe12) and c:IsType(YuL.ST)
end
function cm.pneu_tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocCount(tp,"S")
	local ct=1
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_MZONE) then ct=2 end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.eqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IETarget(cm.eqfilter2,tp,"G",0,ct,nil) and ft>1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,2,0,0)
end
function cm.pneu_op(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocCount(tp,"S")
	if ft<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local dg=Duel.GetMatchingGroup(cm.eqfilter2,tp,LOCATION_GRAVE,0,c)
	Debug.Message(c:GetLocation())
	if #dg>0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local eqg=Group.CreateGroup()
		if c:IsLocation(LOCATION_SZONE) and c:IsRelateToEffect(e)
			and (ft==1 or #dg==1 or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
			eqg:AddCard(c)
			local sg=dg:Select(tp,1,1,nil)
			eqg:Merge(sg)
			c:CancelToGrave()
		else
			local sg=dg:Select(tp,2,2,nil)
			Duel.HintSelection(sg)
			eqg:Merge(sg)
		end
		local eqc=eqg:GetFirst()
		while eqc do
			Duel.Equip(tp,eqc,tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(cm.eqlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			eqc:RegisterEffect(e1)
			eqc=eqg:GetNext()
		end
	end
end
function cm.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() or e:GetHandler():GetEquipTarget()==c
end

--샐비지
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_MODULE
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_EFFECT
end
function cm.thfilter(c)
	return c:IsSetCard(0xe12) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LSTN("G"),0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LSTN("G"))
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LSTN("G"),0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
