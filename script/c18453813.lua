--퓨리티 드라코스트
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"STf")
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,id)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetD(id,0)
	e2:SetCondition(s.con2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STf")
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	if not s.global_check then
		s.global_check=true
		s[0]={}
		s[1]={}
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	s[0]={}
	s[1]={}
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	if r&REASON_COST==0 or not re then
		return false
	end
	return (re:GetActivateLocation()&LSTN("O")~=0 or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and rp==tp
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return false
	end
	if chk==0 then
		return true
	end
	local rc=re:GetHandler()
	if rc:IsLoc("OGR") and rc:IsFaceup() then
		Duel.SetTargetCard(rc)
		Duel.SOI(0,CATEGORY_TOHAND,rc,1,0,0)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function s.con2(e,c,minc)
	if c==nil then
		return true
	end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.ofil3(c,tp)
	local code=c:GetCode()
	return c:IsSSetable() and (code==16960351 or code==47393199) and not s[tp][code]
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SMCard(tp,s.ofil3,tp,"D",0,1,1,nil,tp)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end