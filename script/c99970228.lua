--Orchestra Epilogue
local m=99970228
local cm=_G["c"..m]
function cm.initial_effect(c)

	--바운스 + 데미지
	local e1=YuL.ActST(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--자가 회수
	local e2=MakeEff(c,"STf")
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCode(EVENT_DESTROYED)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
end

--바운스 + 데미지
function cm.thfil(c)
	return c:IsAbleToHand() and c:IsFaceup() and c:IsSetCard(0xd3f)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_MZONE,0,1,nil) end
	local sg=Duel.GetMatchingGroup(cm.thfil,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.thfil,tp,LOCATION_MZONE,0,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	local dg=Duel.GetOperatedGroup()
	if #dg>0 then
	local tc=dg:GetFirst()
	local num=0
	while tc do
		num=num+tc.mystic_orchestra_num
		tc=dg:GetNext()
	end
		Duel.BreakEffect()
		Duel.Damage(1-tp,num*300,REASON_EFFECT)
	end
end

--자가 회수
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
