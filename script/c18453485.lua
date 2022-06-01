--저편의 너머에(비욘드 더 비욘드)
local m=18453485
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function cm.tfil11(c)
	return c:IsSetCard(0xe95) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tfil12(c,tp)
	if not c:IsType(TYPE_MONSTER) or not c:IsAbleToHand() then
		return false
	end
	local g=Duel.GMGroup(Card.IsFaceup,tp,"M",0,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:IsCustomType(CUSTOMTYPE_BEYOND) then
			local blv,blvv=tc:GetBYDLV()
			if blv then
				if tc:GetOriginalLevel()==c:GetLevel() then
					return true
				end
				if blvv then
					if blvv==c:GetLevel() then
						return true
					end
				end
			end
			local batk,batkv=tc:GetBYDATK()
			if batk then
				if tc:GetTextAttack()==c:GetAttack() then
					return true
				end
				if batkv then
					if batkv==c:GetAttack() then
						return true
					end
				end
			end
			local bdef,bdefv=tc:GetBYDDEF()
			if bdef then
				if tc:GetTextDefense()==c:GetDefense() then
					return true
				end
				if bdefv then
					if bdefv==c:GetDefense() then
						return true
					end
				end
			end
		end
		tc=g:GetNext()
	end
	return false
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil11,tp,"D",0,1,nil)
			or (Duel.GetFlagEffect(tp,m)<1 and Duel.IEMCard(cm.tfil12,tp,"D",0,1,nil,tp))
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	if Duel.IEMCard(cm.tfil11,tp,"D",0,1,nil) then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.GetFlagEffect(tp,m)<1 and Duel.IEMCard(cm.tfil12,tp,"D",0,1,nil,tp) then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then
		return
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.tfil11,tp,"D",0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.tfil12,tp,"D",0,1,1,nil,tp)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
end