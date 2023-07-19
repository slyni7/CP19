--브레이브 히어로 킹 아서 브레이버
local m=18453768
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddBraveProcedure(c,aux.FBF(Card.IsRace,RACE_WARRIOR),2,6)
	local e1=MakeEff(c,"I","M")
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCL(1)
	WriteEff(e1,1,"CO")
	c:RegisterEffect(e1)
end
cm.custom_type=CUSTOMTYPE_BRAVE
function cm.cfil11(c,tp)
	local atk=c:GetAttack()
	return c:IsSetCard(0x8)
		and c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(cm.cfil12,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,atk)
end
function cm.cfil12(c,atk)
	return c:IsFaceup() and c:GetAttack()<atk
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local bz=aux.BurningZone[tp]
	local og=Group.CreateGroup()
	for i=1,#bz do
		og:AddCard(bz[i])
	end
	if chk==0 then
		return og:IsExists(cm.cfil11,1,nil,tp)
	end
	local tg=og:FilterSelect(tp,cm.cfil11,1,1,nil,tp)
	local tc=tg:GetFirst()
	local atk=tc:GetAttack()
	e:SetLabel(atk)
	e:SetLabelObject(tc)
	aux.EraseFromBurningZone(tg)
	Duel.SendtoDeck(tg,nil,1,REASON_COST)
end
function cm.ofil1(c,atk)
	return c:IsFaceup() and c:GetAttack()<atk
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=e:GetLabel()
	local g=Duel.GetMatchingGroup(cm.ofil1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,atk)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	local tc=e:GetLabelObject()
	if ct>0 and c:IsRelateToEffect(e) and tc:IsSetCard("브레이브 히어로") then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_UPDATE_BRAVE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(ct*300)
		c:RegisterEffect(e1)
	end
end