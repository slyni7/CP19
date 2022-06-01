--Raining Primrose
local m=99970382
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--장착
	YuL.Equip(c,nil,cm.eqfil)

	--직접 공격
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)

	--필드 클린
	local e2=MakeEff(c,"FTf","S")
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
end

--장착
function cm.eqfil(c)
	return c:IsAttackBelow(1000)
end

--필드 클린
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:GetBattledGroupCount()>0
end
function cm.tgfilter(c)
	return c:IsFaceup() and c:GetAttack()>=1000 and c:IsAbleToGrave()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		local dg=Duel.GetOperatedGroup()
		local tc=dg:GetFirst()
		local atk=0
		while tc do
			local tatk=tc:GetTextAttack()
			if tatk>0 then atk=atk+tatk end
			tc=dg:GetNext()
		end
		Duel.Damage(tp,atk,REASON_EFFECT)
	end
end
