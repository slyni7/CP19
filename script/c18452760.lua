--멜랑홀릭: 메이브레이크 바이러스(다만 이렇게 그대 곁에 있으니)
local m=18452760
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DESTROY)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","G")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCost(aux.bfgcost)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function cm.cfil1(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_TUNER)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=GlobalVirusRelease
	if chk==0 then
		if tc then
			return cm.cfil1(tc) and tc:IsReleasable()
		else
			return Duel.CheckReleaseGroup(tp,cm.cfil1,1,nil)
		end
	end
	local g
	if tc then
		g=Group.FromCards(tc)
	else
		g=Duel.SelectReleaseGroup(tp,cm.cfil1,1,1,nil)
	end
	Duel.Release(g,REASON_COST)
end
function cm.tfil1(c)
	return c:IsLoc("M") or c:IsFaceup()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local g=Duel.GMGroup(cm.tfil1,tp,0,"O",nil)
	local ct=0
	local typ=0
	local tc=g:GetFirst()
	while tc do
		if typ&TYPE_MONSTER<1 and tc:IsLoc("M") then
			typ=typ|TYPE_MONTSER
			ct=ct+1
		elseif typ&TYPE_SPELL<1 and tc:IsType(TYPE_SPELL) then
			typ=typ|TYPE_SPELL
			ct=ct+1
		elseif typ&TYPE_TRAP<1 and tc:IsType(TYPE_TRAP) then
			typ=typ|TYPE_TRAP
			ct=ct+1
		end
		tc=g:GetNext()
	end
	Duel.SOI(0,CATEGORY_DESTROY,g,ct,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LSTN("HO"))
	local typ=0
	if #g>0 then
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g1=g:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
		if #g1>0 then
			typ=typ|TYPE_MONSTER
			g:Sub(g1)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=g:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_SPELL)
		if #g2>0 then
			typ=typ|TYPE_SPELL
			g1:Merge(g2)
			g:Sub(g2)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g3=g:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_TRAP)
		if #g3>0 then
			typ=typ|TYPE_TRAP
			g1:Merge(g3)
			g:Sub(g3)
		end
		Duel.Destroy(g1,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
	local e1=MakeEff(c,"FC")
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DRAW)
	e1:SetOperation(cm.oop11)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	e1:SetLabel(typ)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.ocon12)
	e2:SetOperation(cm.oop12)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,3)
	cm[c]=e2
end
function cm.oop11(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		return
	end
	local hg=eg:Filter(Card.IsLoc,nil,"H")
	if #hg<1 then
		return
	end
	Duel.ConfirmCards(tp,hg)
	local typ=e:GetLabel()
	local g1=Group.CreateGroup()
	if typ&TYPE_MONSTER<1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g1=hg:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
	end
	if #g1>0 then
		typ=typ|TYPE_MONSTER
		hg:Sub(g1)
	end
	local g2=Group.CreateGroup()
	if typ&TYPE_SPELL<1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g2=hg:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_SPELL)
	end
	if #g2>0 then
		typ=typ|TYPE_SPELL
		g1:Merge(g2)
		hg:Sub(g2)
	end
	local g3=Group.CreateGroup()
	if typ&TYPE_TRAP<1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g3=hg:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_TRAP)
	end
	if #g3>0 then
		typ=typ|TYPE_TRAP
		g1:Merge(g3)
		hg:Sub(g3)
	end
	Duel.Destroy(g1,REASON_EFFECT)
	Duel.ShuffleHand(1-tp)
	e:SetLabel(typ)
end
function cm.ocon12(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.oop12(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	ct=ct+1
	e:SetLabel(ct)
	c:SetTurnCounter(ct)
	if ct>2 then
		e:GetLabelObjet():Reset()
		e:GetOwner():ResetFlagEffect(1082946)
	end
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return c:IsControrler(tp) and c:IsLoc("G") and c:IsSetCard(0x2d4) and
			c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	if chk==0 then
		return Duel.IESpSumTarget(Card.IsSetCard,tp,"G",0,1,nil,{e,tp},0x2d4) and
			Duel.GetLocCount(tp,"M")>0
	end
	local g=Duel.SSpSumTarget(tp,Card.IsSetCard,tp,"G",0,1,1,nil,{e,tp},0x2d4)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMON,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end