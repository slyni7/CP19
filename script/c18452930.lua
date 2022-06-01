--벨로시티즌 인포머 로이
local m=18452930
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"F","H")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCondition(cm.con1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FC","M")
	e4:SetCode(EVENT_CHAIN_SOLVING)
	WriteEff(e4,4,"O")
	c:RegisterEffect(e4)
end
cm.square_mana={ATTRIBUTE_DARK}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.nfil1(c)
	return c:IsSetCard(0x2dc) and c:IsFaceup() and c:IsLevelAbove(2)
end
function cm.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(cm.nfil1,tp,"M",0,1,nil)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLevel(1)
end
function cm.cfil3(c)
	return c:IsSetCard(0x2dc) and c:IsFaceup()
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GMGroup(cm.cfil3,tp,"M",0,nil)
	if chk==0 then
		return c:GetFlagEffect(m)<#g
	end
	c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.tfil3(c)
	return c:IsFaceup() and
		((c:GetLevel()>=3 and c:GetLevel()<=10) or (c:GetRank()>=3 and c:GetRank()<=10) or (c:GetLink()>=3 and c:GetLink()<=10))
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and cm.tfil3(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil3,tp,"M","M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.STarget(tp,cm.tfil3,tp,"M","M",1,1,nil)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and c:IsFaceup() and tc:IsFaceup() then
		local lv=0
		if tc:GetLevel()>=3 and tc:GetLevel()<=10 then
			lv=math.max(lv,tc:GetLevel())
		end
		if tc:GetRank()>=3 and tc:GetRank()<=10 then
			lv=math.max(lv,tc:GetRank())
		end
		if tc:GetLink()>=3 and tc:GetLink()<=10 then
			lv=math.max(lv,tc:GetLink())
		end
		if lv<1 then
			return
		end
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(lv-1)
		c:RegisterEffect(e1)
	end
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLevelAbove(2) then
		return
	end
	if c:IsImmuneToEffect(re) then
		return
	end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		return
	end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g<1 then
		return
	end
	if g:IsContains(c) then
		c:ReleaseEffectRelation(re)
		Duel.Hint(HINT_CARD,0,m)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		c:RegisterEffect(e1)
	end
end