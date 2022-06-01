--헤븐 다크사이트 -아연-
local m=18452845
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCountLimit(1,m+1)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tfil1(c,e,tp,eg,ep,ev,re,r,rp,chain)
	if not c:IsAttack(0) or not c:IsType(TYPE_TUNER) or c:IsCode(m) or not c:IsAbleToDeck() then
		return false
	end
	if not c:IsPreviousLocation(LSTN("H")) then
		return false
	end
	if c:GetReason()&REASON_COST<1 then
		return false
	end
	local te=c:GetReasonEffect()
	if not te then
		return false
	end
	if not te:IsHasType(EFFECT_TYPE_ACTIONS) then
		return false
	end
	local tc=te:GetHandler()
	if c~=tc then
		return false
	end
	local con=te:GetCondition()
	local tg=te:GetTarget()
	local event=te:GetCode()
	if te:GetCode()==EVENT_FREE_CHAIN then
		if (not con or con(te,tp,eg,ep,ev,re,r,rp))
			and (not tg or tg(te,tp,eg,ep,ev,re,r,rp,0)) then
			return true
		end
	elseif te:GetCode()==EVENT_CHAINING then
		if chain>0 then
			local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
			local cc=ce:GetHandler()
			local cg=Group.FromCards(cc)
			local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
			if (not con or con(te,tp,cg,cp,chain,ce,REASON_EFFECT,cp))
				and (not tg or tg(te,tp,cg,cp,chain,ce,REASON_EFFECT,cp,0)) then
				return true
			end
		end
	else
		local tres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
		if tres and (not con or con(te,tp,teg,tep,tev,tre,tr,trp))
			and (not tg or tg(te,tp,teg,tev,tre,tr,trp,0)) then
			return true
		end
	end
	return false
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil1(chkc)
	end
	if chk==0 then
		local chain=Duel.GetCurrentChain()
		return Duel.IETarget(cm.tfil1,tp,"G",0,1,nil,e,tp,eg,ep,ev,re,r,rp,chain)
	end
	local chain=Duel.GetCurrentChain()-1
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.STarget(tp,cm.tfil1,tp,"G",0,1,1,nil,e,tp,eg,ep,ev,re,r,rp,chain)
	local tc=g:GetFirst()
	local te=tc:GetReasonEffect()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if te:GetCode()==EVENT_CHAINING then
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		if tg then
			tg(e,tp,cg,cp,chain,ce,REASON_EFFECT,cp,1)
		end
	elseif te:GetCode()==EVENT_FREE_CHAIN then
		if tg then
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	else
		local tres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
		if tg then
			tg(e,tp,teg,tep,tev,tre,tr,trp,1)
		end
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then
		return
	end
	local chain=Duel.GetCurrentChain()-1
	local te=tc:GetReasonEffect()
	local op=te:GetOperation()
	if te:GetCode()==EVENT_CHAINING then
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		if op then
			op(e,tp,cp,cp,chain,ce,REASON_EFFECT,cp)
		end
	elseif te:GetCode()==EVENT_FREE_CHAIN then
		if op then
			op(e,tp,eg,ep,ev,re,r,rp)
		end
	else
		local tres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
		if op then
			op(e,tp,teg,tep,tev,tre,tr,trp)
		end
	end
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	if r&REASON_EFFECT<1 then
		return false
	end
	local rc=re:GetHandler()
	return rc:IsSetCard(0x2d9)
end
function cm.tfil21(c,e,tp)
	return c:IsSetCard(0x2d9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
		and not Duel.IEMCard(cm.tfil22,tp,"OG",0,1,nil,c:GetCode())
end
function cm.tfil22(c,code)
	return c:IsCode(code) and c:IsFaceup()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(cm.tfil21,tp,"D",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil21,tp,"D",0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end